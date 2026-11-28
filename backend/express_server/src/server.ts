import app from './app';
import { testDBConnection } from './config/db';
import dotenv from 'dotenv';

dotenv.config();

const PORT = Number(process.env.PORT) || 5000;
const IP = process.env.IP || "0.0.0.0";

const startServer = async () => {
    // Test database connection before launching server
    await testDBConnection();

    app.listen(PORT, IP, () => {
        console.log(`🚀 Server KasKita berjalan di port ${PORT} / ${IP}`);
    });
};

startServer();