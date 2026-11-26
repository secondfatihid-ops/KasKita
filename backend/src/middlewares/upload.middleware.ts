import multer from 'multer';
import { Request } from 'express';

// Use memory storage so files are kept in buffer for Cloudinary streaming
const storage = multer.memoryStorage();

// File filter to accept only image files (JPEG, PNG, JPG)
const fileFilter = (req: Request, file: Express.Multer.File, cb: multer.FileFilterCallback) => {
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png' || file.mimetype === 'image/jpg') {
        cb(null, true);
    } else {
        cb(new Error('Format file tidak didukung! Hanya file gambar (JPEG, JPG, PNG) yang diperbolehkan.'));
    }
};

// Configure upload limits (e.g., max 5MB per receipt image)
const upload = multer({
    storage: storage,
    fileFilter: fileFilter,
    limits: {
        fileSize: 5 * 1024 * 1024 // 5MB limit
    }
});

export default upload;