import { Router } from 'express';
import { 
    getCategories, 
    createCategory, 
    updateCategory, 
    deleteCategory 
} from '../controllers/category.controller';
import { verifyToken } from '../middlewares/auth.middleware';
import { requireOwner } from '../middlewares/role.middleware';

const router = Router();

// GET /api/categories - Accessible by all authenticated users (owner & cashier)
router.get('/', verifyToken, getCategories);

// POST /api/categories - Owner only
router.post('/', verifyToken, requireOwner, createCategory);

// PUT /api/categories/:id - Owner only
router.put('/:id', verifyToken, requireOwner, updateCategory);

// DELETE /api/categories/:id - Owner only
router.delete('/:id', verifyToken, requireOwner, deleteCategory);

export default router;