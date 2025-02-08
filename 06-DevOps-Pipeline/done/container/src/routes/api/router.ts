import Router from 'express-promise-router';
import getAll from './get-all';
import getOne from './get-one';
import post from './post';


const router = Router();

router.get('/', getAll);
router.get('/:id', getOne);
router.post('/:id', post);

export default router;
