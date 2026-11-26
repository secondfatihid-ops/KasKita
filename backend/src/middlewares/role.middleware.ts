import { Request, Response, NextFunction } from 'express';

// Middleware to check if the user is an Owner (role_id = 1) or Cashier (role_id = 2)
export const requireOwner = (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user) {
        res.status(401).json({
            success: false,
            message: 'Unauthorized! Pengguna tidak terautentikasi.'
        });
        return;
    }

    // Assuming role_id 1 is 'owner' based on our MySQL seed data
    if (req.user.role_id !== 1) {
        res.status(403).json({
            success: false,
            message: 'Akses ditolak! Fitur ini khusus untuk Owner.'
        });
        return;
    }

    next();
};