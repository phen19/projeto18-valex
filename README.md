# projeto18-valex



<p align="center">
  <img  src="https://cdn.iconscout.com/icon/free/png-256/credit-card-2650080-2196542.png">
</p>
<h1 align="center">
  Valex
</h1>
<div align="center">

  <h3>Built With</h3>

  <img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white" height="30px"/>
  <img src="https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white" height="30px"/>
  <img src="https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white" height="30px"/>  
  <img src="https://img.shields.io/badge/Express.js-404D59?style=for-the-badge&logo=express.js&logoColor=white" height="30px"/>
  <!-- Badges source: https://dev.to/envoy_/150-badges-for-github-pnk -->
</div>

# Rotas de criação e gerenciamento de cartões:

## Rota <span style="color:yellow"> **POST** </span>/newCard

Essa é uma rota autenticada com um header http do tipo "x-api-key". Sua função é criar novos cartões para os funcionários.

O Body da requisição deve ser feito no seguinte formato:

```json
{
  "employeeId": "id_do_funcionario", //number
  "type": "tipo_do_cartão" //string
}
```

## Rota <span style="color:orange"> **PATCH** </span>/activateCard/:id

Essa é uma rota não autenticada. Sua função é ativar os cartões criados.

O "id" passado na rota é o id do cartão criado na rota mencionada anteriormente.

O Body da requisição deve ser feito no seguinte formato:

```json
{
  "securityCode": "cvc_do_cartao", //string
  "password": "senha_escolhida" //string
}
```

## Rota <span style="color:green"> **GET** </span>/cardBalance/:id

Essa é uma rota não autenticada. Sua função é verificar o extrato dos cartões.

O "id" passado na rota é o id do cartão criado.

A resposta da requisição virá no seguinte formato:

```json
"balance": 35000,
  "transactions": [
		{ "id": 1, "cardId": 1, "businessId": 1, "businessName": "DrivenEats", "timestamp": "22/01/2022", "amount": 5000 }
	]
  "recharges": [
		{ "id": 1, "cardId": 1, "timestamp": "21/01/2022", "amount": 40000 }
	]
```

## Rotas <span style="color:orange"> **PATCH** </span>/blockAndUnblockCard/:id

Rota não autenticada com o intuito de permitir ao usuário respectivamente bloquear e desbloquear um cartão.

O "id" passado na rota é o id do cartão criado.

A ação a ser realizada deve ser passada pelo header http, como "action: block" ou "action:unblock"

O Body da requisição deve ser feito no seguinte formato:

```json
{
  "password": "senha_do_cartão" //string
}
```

# Rotas de compra e recarga:

## Rota <span style="color:yellow"> **POST** </span>/recharge/:id

Essa é uma rota autenticada com um header http do tipo "x-api-key". Sua função é recarregar os cartões para os funcionários.

O "id" passado na rota é o id do cartão criado.

O Body da requisição deve ser feito no seguinte formato:

```json
{
  "amount": "valor_escolhido" //number
}
```

## Rota <span style="color:yellow"> **POST** </span>/purchase/:id

Essa é uma rota não autenticada. Sua função é permitir aos funcionários fazerem compras em estabelecimentos **do mesmo tipo** dos seus cartões.

O "id" passado na rota é o id do cartão criado.

O Body da requisição deve ser feito no seguinte formato:

```json
{
  "password": "senha_do_cartão", //string
  "businessId": "id_do_estabelecimento", //number
  "amount": "valor_da_compra" //number
}
