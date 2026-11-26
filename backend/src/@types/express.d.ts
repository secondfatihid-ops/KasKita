import { Request } from 'express';

export interface UserPayload {
    id: number;
    role_id: number;
    email: string;
}

declare global {
    namespace Express {
        interface Request {
            user?: UserPayload;
        }
    }
}

export interface AuthRequest extends Request {
    user?: UserPayload;
}