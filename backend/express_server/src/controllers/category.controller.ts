import { Request, Response } from 'express';
import pool from '../config/db';
import { RowDataPacket, ResultSetHeader } from 'mysql2';

// 1. Get All Categories
export const getCategories = async (req: Request, res: Response): Promise<void> => {
    try {
        const [categories] = await pool.query<RowDataPacket[]>(
            'SELECT * FROM categories ORDER BY id ASC'
        );

        res.status(200).json({
            success: true,
            message: 'Berhasil mengambil data kategori.',
            data: categories
        });
    } catch (error) {
        console.error('Error fetching categories:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat mengambil kategori.'
        });
    }
};

// 2. Create New Category (Owner Only)
export const createCategory = async (req: Request, res: Response): Promise<void> => {
    try {
        const { name, type } = req.body;

        if (!name || !type) {
            res.status(400).json({
                success: false,
                message: 'Nama kategori dan tipe (income/expense) wajib diisi!'
            });
            return;
        }

        if (type !== 'income' && type !== 'expense') {
            res.status(400).json({
                success: false,
                message: 'Tipe kategori harus bernilai "income" atau "expense".'
            });
            return;
        }

        const [result] = await pool.query<ResultSetHeader>(
            'INSERT INTO categories (name, type) VALUES (?, ?)',
            [name, type]
        );

        res.status(201).json({
            success: true,
            message: 'Kategori berhasil ditambahkan!',
            data: {
                id: result.insertId,
                name,
                type
            }
        });
    } catch (error) {
        console.error('Error creating category:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat menambah kategori.'
        });
    }
};

// 3. Update Category (Owner Only)
export const updateCategory = async (req: Request, res: Response): Promise<void> => {
    try {
        const { id } = req.params;
        const { name, type } = req.body;

        if (!name || !type) {
            res.status(400).json({
                success: false,
                message: 'Nama kategori dan tipe wajib diisi!'
            });
            return;
        }

        const [existing] = await pool.query<RowDataPacket[]>(
            'SELECT id FROM categories WHERE id = ?',
            [id]
        );

        if (existing.length === 0) {
            res.status(404).json({
                success: false,
                message: 'Kategori tidak ditemukan.'
            });
            return;
        }

        await pool.query(
            'UPDATE categories SET name = ?, type = ? WHERE id = ?',
            [name, type, id]
        );

        res.status(200).json({
            success: true,
            message: 'Kategori berhasil diperbarui!'
        });
    } catch (error) {
        console.error('Error updating category:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat memperbarui kategori.'
        });
    }
};

// 4. Delete Category (Owner Only)
export const deleteCategory = async (req: Request, res: Response): Promise<void> => {
    try {
        const { id } = req.params;

        const [existing] = await pool.query<RowDataPacket[]>(
            'SELECT id FROM categories WHERE id = ?',
            [id]
        );

        if (existing.length === 0) {
            res.status(404).json({
                success: false,
                message: 'Kategori tidak ditemukan.'
            });
            return;
        }

        await pool.query('DELETE FROM categories WHERE id = ?', [id]);

        res.status(200).json({
            success: true,
            message: 'Kategori berhasil dihapus!'
        });
    } catch (error) {
        console.error('Error deleting category:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat menghapus kategori.'
        });
    }
};