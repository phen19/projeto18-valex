import * as cardRepository from "../repositories/cardRepository.js"
import * as employeeRepository from "../repositories/employeeRepository.js"
import * as companyRepository from "../repositories/companyRepository.js"
import { faker } from '@faker-js/faker';
import dayjs from "dayjs";
import Cryptr from "cryptr";
import dotenv from "dotenv";

dotenv.config()
const cryptr = new Cryptr(process.env.SECRET_KEY)

export async function newCardInfoValidation(id: number, api: string, type: cardRepository.TransactionTypes){
    const employee = await employeeRepository.findById(id); 
    
    if(!employee) {
        throw { code: 'NotFound', message: 'Funcionário não encontrado' }
    }

    const company = await companyRepository.findByApiKey(api)

    if(!company){
        throw { code:'NotFound', message: 'Empresa não encontrada com esta API Key'}
    }

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
    console.log(securityCode)
    console.log(cryptr.decrypt(securityCode))

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

    await cardRepository.insert(cardData)
}