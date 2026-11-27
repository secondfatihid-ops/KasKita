import { Router } from 'express';
import { 
    getTransactions, 
    createTransaction, 
    updateTransaction, 
    deleteTransaction 
} from '../controllers/transaction.controller';
import { verifyToken } from '../middlewares/auth.middleware';
import upload from '../middlewares/upload.middleware';

const router = Router();

// All transaction routes require authentication
router.use(verifyToken);

// GET /api/transactions
router.get('/', getTransactions);

// POST /api/transactions (supports single image upload field named 'receipt_image')
router.post('/', upload.single('receipt_image'), createTransaction);

// PUT /api/transactions/:id
router.put('/:id', upload.single('receipt_image'), updateTransaction);

// DELETE /api/transactions/:id
router.delete('/:id', deleteTransaction);

export default router;