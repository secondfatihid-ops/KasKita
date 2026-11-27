import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export const verifyToken = (req: Request, res: Response, next: NextFunction): void => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer <token>

    if (!token) {
        res.status(401).json({
            success: false,
            message: 'Akses ditolak! Token autentikasi tidak ditemukan.'
        });
        return;
    }

    try {
        const secret = process.env.JWT_SECRET || 'default_secret';
        const decoded = jwt.verify(token, secret) as { id: number; role_id: number; email: string };
        
        req.user = decoded; // Attach user info to request
        next();
    } catch (error) {
        res.status(403).json({
            success: false,
            message: 'Token tidak valid atau sudah kadaluarsa.'
        });
        return;
    }
};