import { Router } from "express"
import { activateCard, createCard, cardBalance } from "../controllers/cardController.js";
import { validateAPIKey } from "../middlewares/cardMiddleware.js";
import { schemaValidator } from "../middlewares/schemaValidator.js";
import { schemas } from "../schemas/schemas.js";


const cardRouter = Router();


cardRouter.post("/newCard", validateAPIKey, schemaValidator(schemas.newCardSchema), createCard)
cardRouter.patch("/activateCard",schemaValidator(schemas.activateCard),activateCard)
cardRouter.get("/cardBalance/:id", cardBalance)
export default cardRouter;