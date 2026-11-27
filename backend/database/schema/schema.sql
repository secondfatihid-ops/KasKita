-- Buat Database
CREATE DATABASE IF NOT EXISTS db_kaskita;
USE db_kaskita;

-- 1. Tabel roles (Peran pengguna: owner dan cashier)
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Seed data untuk roles
INSERT INTO roles (role_name) VALUES ('owner'), ('cashier');

-- 2. Tabel users (Data akun pengguna dengan relasi ke roles)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Disimpan dalam bentuk hash bcrypt
    role_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- 3. Tabel categories (Kategori transaksi arus kas: income / expense)
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM('income', 'expense') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed data awal untuk kategori UMKM
INSERT INTO categories (name, type) VALUES 
('Penjualan Tunai', 'income'),
('Pendapatan Jasa', 'income'),
('Pembelian Bahan Baku', 'expense'),
('Biaya Utilitas (Listrik/Air/Internet)', 'expense'),
('Gaji Karyawan', 'expense');

-- 4. Tabel transactions (Pencatatan transaksi keuangan & bukti nota)
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    description TEXT,
    receipt_image VARCHAR(255), -- Path atau URL file gambar nota yang diunggah
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);