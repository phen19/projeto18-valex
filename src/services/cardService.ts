import * as cardRepository from "../repositories/cardRepository.js"
import * as employeeRepository from "../repositories/employeeRepository.js"
import * as companyRepository from "../repositories/companyRepository.js"
import * as paymentRepository from "../repositories/paymentRepository.js"
import * as rechargeRepository from "../repositories/rechargeRepository.js"
import * as businessRepository from "../repositories/businessRepository.js"
import { faker } from '@faker-js/faker';
import dayjs from "dayjs";
import isSameOrAfter from "dayjs/plugin/isSameOrAfter.js"
import customParseFormat from "dayjs/plugin/customParseFormat.js"
import Cryptr from "cryptr";
import dotenv from "dotenv";
import bcrypt from "bcryptjs";

dotenv.config()
const cryptr = new Cryptr(process.env.SECRET_KEY)
dayjs.extend(customParseFormat);
dayjs.extend(isSameOrAfter)

async function validateCardbyId(id: number){
    const card = await cardRepository.findById(id);
    if(!card){
        throw { code: 'NotFound', message: 'Cartão não encontrado' }
    }

    const today = dayjs(dayjs(), "MM/YY");
    const expirationDate = dayjs(card.expirationDate, "MM/YY")
    const hasExpired:boolean = today.isSameOrAfter(expirationDate, "month")

    if(hasExpired) {
        throw {code: 'Unauthorized', message:'Cartão expirado'}
    }
    return card
}

async function isValidAPIKey(api:string){
    const company = await companyRepository.findByApiKey(api)

    if(!company){
        throw { code:'NotFound', message: 'Empresa não encontrada com esta API Key'}
    }
}

async function isCardActive(id:number){
    const card = await cardRepository.findById(id);
    if(card.password === null){
        throw { code: 'Unauthorized', message: 'Cartão não está ativo'};
        
    }
}

export async function newCardInfoValidation(id: number, api: string, type: cardRepository.TransactionTypes){
    const employee = await employeeRepository.findById(id); 
    
    if(!employee) {
        throw { code: 'NotFound', message: 'Funcionário não encontrado' }
    }

    await isValidAPIKey(api)

    const hasCard = await cardRepository.findByTypeAndEmployeeId(type, id)

    if(hasCard){
        throw {code:'Conflict', message: 'Funcionário já possui cartão deste tipo'}
    }

    return employee
}

export async function createCard(id: number, api: string, type: cardRepository.TransactionTypes){
    const cardNumber :string = faker.finance.creditCardNumber('mastercard')
    const name = await newCardInfoValidation(id, api, type)

    const fullName:string [] = name.fullName.toUpperCase().split(' ') 
    const cardholderName: string = fullName.filter((name, index) => index===0 || index===fullName.length -1 || name.length>=3)
        .map((name, index, array)=> index!==0 && index !== array.length-1 ? name[0] : name).join(' ')

    const date:string[] = dayjs().format('MM/YY').split("/")
    const expirationDate: string = `${date[0]}/${parseInt(date[1])+5}`
    
    const securityCode :string= cryptr.encrypt(faker.finance.creditCardCVV())

    const cardData :cardRepository.CardInsertData= {
        employeeId: id,
        number: cardNumber,
        cardholderName,
        securityCode,
        expirationDate,
        isVirtual: false,
        isBlocked: true,
        type,
    }

    const result = await cardRepository.insert(cardData)
    return {
        cardId: result.cardId,
        number: cardNumber,
        securityCode: cryptr.decrypt(securityCode),
        expirationDate,
        type
    }
}

export async function activateCard(id:number, securityCode: string, password: string){
    const card = await validateCardbyId(id)

    if(card.password !== null){
        throw { code: 'Conflict', message: 'Cartão já está ativo'};
        
    }

    const securityCodeDescrypted: string = cryptr.decrypt(card.securityCode)

    if(securityCodeDescrypted.length !== 3 || !securityCodeDescrypted || securityCodeDescrypted !== securityCode) {
        throw { code: 'Unauthorized', message: 'Código CVV inválido'};
    }

    const passwordEncrypted :string = bcrypt.hashSync(password, 10);

    await cardRepository.update(id, { password: passwordEncrypted })

}

export async function cardBalance(id:number){
    await validateCardbyId(id)
    await isCardActive(id)

    const payments = await paymentRepository.findByCardId(id);
    const rechargesNoFormat = await rechargeRepository.findByCardId(id);

    const paymentsAmount:number = payments.map((p) => p.amount).reduce((sum: number, current: number) => sum + current,0);
    const rechargesAmount:number = rechargesNoFormat.map((r) => r.amount).reduce((sum: number, current:number) => sum + current,0);
    const balance:number = rechargesAmount - paymentsAmount

    const transactions = payments.map((p)=>{return { ...p, timestamp: dayjs(p.timestamp).format("DD/MM/YYYY")}})
    const recharges = rechargesNoFormat.map((r)=>{return { ...r, timestamp: dayjs(r.timestamp).format("DD/MM/YYYY")}})

    return { balance, 
            transactions,
            recharges}
}

export async function blockAndUnblockCard(id:number, password: string, action: string){
    const card = await validateCardbyId(id);

    const checkPassword = bcrypt.compareSync(password, card.password);

    if (!checkPassword) {
      throw {code: 'Unauthorized', message: 'Senha inválida'};
    }

    if(action === 'block'){
        if (card.isBlocked === true){
            throw {code: 'Conflict', message: 'Cartão já bloqueado'}
        }
        return await cardRepository.update(id, {isBlocked: true})
    }

    if(action === 'unblock'){
        if (card.isBlocked === false){
            throw {code: 'Conflict', message: 'Cartão já desbloqueado'}
        }
        return await cardRepository.update(id, {isBlocked: false})
    }


}

async function isBlocked(id:number){
    const card = await cardRepository.findById(id);
    if (card.isBlocked === true){
        throw {code: 'Unauthorized', message: 'Cartão bloqueado'}
    }
}

export async function rechargeCard(id:number, amount:number, api:string){
    await isValidAPIKey(api)
    await isCardActive(id)
    await validateCardbyId(id)

    await rechargeRepository.insert({cardId:id, amount:amount})
}

export async function purchase(cardId:number, password:string, businessId:number, amount:number){
    const card = await validateCardbyId(cardId);
    await isCardActive(cardId);
    await isBlocked(cardId);
    const checkPassword = bcrypt.compareSync(password, card.password);

    if (!checkPassword) {
      throw {code: 'Unauthorized', message: 'Senha inválida'};
    }

    const business = await validateBusiness(businessId, card.type)

    const {balance} = await cardBalance(cardId)

    if(balance - amount < 0){
        throw {code: 'Unauthorized', message: 'Saldo insuficiente'}
    }

    await paymentRepository.insert({cardId:cardId, businessId: businessId, amount:amount})
}

async function validateBusiness(id:number, cardType: cardRepository.TransactionTypes){
    const business = await businessRepository.findById(id)

    if(!business){
        throw { code: 'NotFound', message: 'Estabelecimento não encontrado' }
    }

    if(business.type!== cardType){
        throw {code: 'Unauthorized', message: 'Tipo de cartão não confere com o tipo de estabelecimento'}
    }

    return business
}