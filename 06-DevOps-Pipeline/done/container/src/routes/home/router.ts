import Router from 'express-promise-router';
import get from './get';


const router = Router();

router.get('/', get);

export default router;
