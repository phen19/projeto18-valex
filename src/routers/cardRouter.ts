import { Router } from "express"
import { activateCard, createCard, cardBalance, blockAndUnblockCard} from "../controllers/cardController.js";
import { validateAPIKey } from "../middlewares/cardMiddleware.js";
import { schemaValidator } from "../middlewares/schemaValidator.js";
import { schemas } from "../schemas/schemas.js";


const cardRouter = Router();


cardRouter.post("/newCard", validateAPIKey, schemaValidator(schemas.newCardSchema), createCard)
cardRouter.patch("/activateCard",schemaValidator(schemas.activateCardSchema),activateCard)
cardRouter.get("/cardBalance/:id", cardBalance)
cardRouter.patch("/blockAndUnblockCard/:id", schemaValidator(schemas.blockAndUnblockCardSchema),blockAndUnblockCard)
//cardRouter.patch("/unblockCard/:id", schemaValidator(schemas.blockAndUnblockCardSchema),unblockCard)
export default cardRouter;