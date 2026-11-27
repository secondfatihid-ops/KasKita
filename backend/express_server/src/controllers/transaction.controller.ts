import { Response } from 'express';
import { Readable } from 'stream';
import pool from '../config/db';
import cloudinary from '../config/cloudinary';
import { RowDataPacket, ResultSetHeader } from 'mysql2';
import { AuthRequest } from '../@types/express';

// Helper function to upload buffer to Cloudinary using Node.js stream
const uploadToCloudinary = (fileBuffer: Buffer): Promise<any> => {
    return new Promise((resolve, reject) => {
        const uploadStream = cloudinary.uploader.upload_stream(
            { folder: 'kaskita_receipts' },
            (error, result) => {
                if (error) return reject(error);
                resolve(result);
            }
        );
        Readable.from(fileBuffer).pipe(uploadStream);
    });
};

// 1. Get All Transactions
export const getTransactions = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const [transactions] = await pool.query<RowDataPacket[]>(
            `SELECT t.*, u.name AS user_name, c.name AS category_name, c.type AS category_type 
             FROM transactions t
             JOIN users u ON t.user_id = u.id
             JOIN categories c ON t.category_id = c.id
             ORDER BY t.created_at DESC`
        );

        res.status(200).json({
            success: true,
            message: 'Berhasil mengambil data transaksi.',
            data: transactions
        });
    } catch (error) {
        console.error('Error fetching transactions:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat mengambil transaksi.'
        });
    }
};

// 2. Create Transaction (with Cloudinary Receipt Upload)
export const createTransaction = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const { category_id, amount, description } = req.body;
        const user_id = req.user?.id;

        if (!user_id) {
            res.status(401).json({ success: false, message: 'Unauthorized!' });
            return;
        }

        if (!category_id || !amount) {
            res.status(400).json({
                success: false,
                message: 'Kategori dan jumlah nominal (amount) wajib diisi!'
            });
            return;
        }

        let receiptImageUrl = null;

        // If file is uploaded, send buffer to Cloudinary
        if (req.file) {
            try {
                const cloudinaryResult: any = await uploadToCloudinary(req.file.buffer);
                receiptImageUrl = cloudinaryResult.secure_url;
            } catch (uploadError) {
                console.error('Cloudinary upload error:', uploadError);
                res.status(500).json({
                    success: false,
                    message: 'Gagal mengunggah foto nota ke Cloudinary.'
                });
                return;
            }
        }

        const [result] = await pool.query<ResultSetHeader>(
            `INSERT INTO transactions (user_id, category_id, amount, description, receipt_image) 
             VALUES (?, ?, ?, ?, ?)`,
            [user_id, category_id, amount, description || null, receiptImageUrl]
        );

        res.status(201).json({
            success: true,
            message: 'Transaksi berhasil dicatat!',
            data: {
                id: result.insertId,
                user_id,
                category_id,
                amount,
                description,
                receipt_image: receiptImageUrl
            }
        });
    } catch (error) {
        console.error('Error creating transaction:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat mencatat transaksi.'
        });
    }
};

// 3. Update Transaction
export const updateTransaction = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const { id } = req.params;
        const { category_id, amount, description } = req.body;

        const [existing] = await pool.query<RowDataPacket[]>(
            'SELECT * FROM transactions WHERE id = ?',
            [id]
        );

        if (existing.length === 0) {
            res.status(404).json({ success: false, message: 'Transaksi tidak ditemukan.' });
            return;
        }

        let receiptImageUrl = existing[0].receipt_image;

        // If new file is uploaded, replace image on Cloudinary
        if (req.file) {
            try {
                const cloudinaryResult: any = await uploadToCloudinary(req.file.buffer);
                receiptImageUrl = cloudinaryResult.secure_url;
            } catch (uploadError) {
                console.error('Cloudinary upload error:', uploadError);
                res.status(500).json({ success: false, message: 'Gagal mengunggah foto nota baru.' });
                return;
            }
        }

        await pool.query(
            `UPDATE transactions SET category_id = ?, amount = ?, description = ?, receipt_image = ? WHERE id = ?`,
            [category_id, amount, description, receiptImageUrl, id]
        );

        res.status(200).json({
            success: true,
            message: 'Transaksi berhasil diperbarui!'
        });
    } catch (error) {
        console.error('Error updating transaction:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat memperbarui transaksi.'
        });
    }
};

// 4. Delete Transaction
export const deleteTransaction = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const { id } = req.params;

        const [existing] = await pool.query<RowDataPacket[]>(
            'SELECT id FROM transactions WHERE id = ?',
            [id]
        );

        if (existing.length === 0) {
            res.status(404).json({ success: false, message: 'Transaksi tidak ditemukan.' });
            return;
        }

        await pool.query('DELETE FROM transactions WHERE id = ?', [id]);

        res.status(200).json({
            success: true,
            message: 'Transaksi berhasil dihapus!'
        });
    } catch (error) {
        console.error('Error deleting transaction:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat menghapus transaksi.'
        });
    }
};