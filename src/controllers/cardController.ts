import {Request, Response} from "express";
import * as cardService from "../services/cardService.js"
import { TransactionTypes } from "../repositories/cardRepository.js";

export async function createCard(req: Request, res: Response) {
    const id:number = req.body.employeeId
    const type:TransactionTypes = req.body.type
    const { "x-api-key": API_KEY } = req.headers;

    const result = await cardService.createCard(id, API_KEY.toString(), type)
 

    res.status(201).send(result)
}

export async function activateCard(req: Request, res: Response){
    const id:number = parseInt(req.params.id);
    const securityCode:string = req.body.securityCode;
    const password:string = req.body.password;

    const result=await cardService.activateCard(id, securityCode, password)

    res.send("Cartão ativado")
}

export async function cardBalance(req: Request, res: Response){
    const id:number =parseInt(req.params.id)

    const result = await cardService.cardBalance(id)

    res.status(200).send(result)
}

export async function blockAndUnblockCard(req: Request, res: Response){
    const id:number = parseInt(req.params.id)
    const password:string = req.body.password;  
    const action:string= req.headers.action.toString();


    await cardService.blockAndUnblockCard(id,password, action)
    res.status(200).send("OK")
}

export async function rechargeCard(req: Request, res: Response){
    const id:number =parseInt(req.params.id)
    const { "x-api-key": API_KEY } = req.headers;
    const amount:number = req.body.amount;

    await cardService.rechargeCard(id,amount,API_KEY.toString())
    res.status(201).send("recarga efetuada")
}

export async function purchase(req: Request, res: Response){
    const cardId:number = parseInt(req.params.id);
    const password:string = req.body.password;
    const businessId:number = parseInt(req.body.businessId)
    const amount:number= req.body.amount;

    await cardService.purchase(cardId, password, businessId, amount)
    res.status(201).send("compra efetuada")
}