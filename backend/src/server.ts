import app from './app';
import { testDBConnection } from './config/db';
import dotenv from 'dotenv';

dotenv.config();

const PORT = process.env.PORT || 5000;

const startServer = async () => {
    // Test database connection before launching server
    await testDBConnection();

    app.listen(PORT, () => {
        console.log(`🚀 Server KasKita berjalan di port ${PORT}`);
    });
};

startServer();