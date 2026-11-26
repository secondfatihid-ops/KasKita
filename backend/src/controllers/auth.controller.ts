import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pool from '../config/db';
import { RowDataPacket, ResultSetHeader } from 'mysql2';

// 1. Register User (Owner or Cashier)
export const register = async (req: Request, res: Response): Promise<void> => {
    try {
        if (!req.body) {
            res.status(400).json({
                success: false,
                message: 'Request body tidak ditemukan. Pastikan header Content-Type: application/json dikirim.'
            });
            return;
        }

        const { name, email, password, role_id } = req.body;

        // Validation check
        if (!name || !email || !password || !role_id) {
            res.status(400).json({
                success: false,
                message: 'Semua field (name, email, password, role_id) wajib diisi!'
            });
            return;
        }

        // Check if email already exists
        const [existingUsers] = await pool.query<RowDataPacket[]>(
            'SELECT id FROM users WHERE email = ?',
            [email]
        );

        if (existingUsers.length > 0) {
            res.status(400).json({
                success: false,
                message: 'Email sudah terdaftar. Silakan gunakan email lain.'
            });
            return;
        }

        // Hash password securely with bcrypt
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        // Insert new user into database
        const [result] = await pool.query<ResultSetHeader>(
            'INSERT INTO users (name, email, password, role_id) VALUES (?, ?, ?, ?)',
            [name, email, hashedPassword, role_id]
        );

        res.status(201).json({
            success: true,
            message: 'Registrasi berhasil!',
            data: {
                userId: result.insertId,
                name,
                email,
                role_id
            }
        });
    } catch (error) {
        console.error('Error during registration:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat registrasi.'
        });
    }
};

// 2. Login User
export const login = async (req: Request, res: Response): Promise<void> => {
    try {
        if (!req.body) {
            res.status(400).json({
                success: false,
                message: 'Request body tidak ditemukan. Pastikan header Content-Type: application/json dikirim.'
            });
            return;
        }

        const { email, password } = req.body;

        // Validation check
        if (!email || !password) {
            res.status(400).json({
                success: false,
                message: 'Email dan password wajib diisi!'
            });
            return;
        }

        // Find user by email
        const [users] = await pool.query<RowDataPacket[]>(
            'SELECT users.*, roles.role_name FROM users JOIN roles ON users.role_id = roles.id WHERE users.email = ?',
            [email]
        );

        if (users.length === 0) {
            res.status(401).json({
                success: false,
                message: 'Email atau password salah!'
            });
            return;
        }

        const user = users[0];

        // Verify password match
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            res.status(401).json({
                success: false,
                message: 'Email atau password salah!'
            });
            return;
        }

        // Generate JWT Token
        const secret = process.env.JWT_SECRET || 'default_secret';
        const token = jwt.sign(
            {
                id: user.id,
                email: user.email,
                role_id: user.role_id
            },
            secret,
            { expiresIn: '1d' } // Token valid for 1 day
        );

        res.status(200).json({
            success: true,
            message: 'Login berhasil!',
            token,
            data: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role_name
            }
        });
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({
            success: false,
            message: 'Terjadi kesalahan pada server saat login.'
        });
    }
};