-- =====================================================================
-- KasKita - MSME Cash Book Application
-- Database schema (MySQL 8.0.16 or newer, because of CHECK constraints)
--
-- Tables : roles, users, categories, transactions, attachments
-- Run    : schema.sql first, then seed.sql
-- Note   : uses IF NOT EXISTS, so it is safe to run more than once and
--          never drops existing data.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS kaskita
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE kaskita;

-- ---------------------------------------------------------------------
-- roles: the access levels of the system (owner, staff)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS roles (
  id    INT         NOT NULL AUTO_INCREMENT,
  name  VARCHAR(30) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_roles_name (name)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- users: accounts that can log in
-- password_hash stores a bcrypt hash, never the plain password.
-- Users are deactivated (is_active = 0) instead of deleted, so their
-- transactions are never lost.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id             INT          NOT NULL AUTO_INCREMENT,
  role_id        INT          NOT NULL,
  name           VARCHAR(100) NOT NULL,
  email          VARCHAR(100) NOT NULL,
  password_hash  VARCHAR(255) NOT NULL,
  is_active      TINYINT(1)   NOT NULL DEFAULT 1,
  created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                              ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_email (email),
  CONSTRAINT fk_users_role
    FOREIGN KEY (role_id) REFERENCES roles (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- categories: groups for transactions (e.g. Sales, Supplies)
-- The type of a transaction (income or expense) comes from its category.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  id          INT                       NOT NULL AUTO_INCREMENT,
  name        VARCHAR(60)               NOT NULL,
  type        ENUM('income', 'expense') NOT NULL,
  created_at  DATETIME                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_categories_name_type (name, type)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- transactions: one cash movement recorded by a user
-- A user or category that still has transactions cannot be deleted
-- (ON DELETE RESTRICT) so financial records stay intact.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS transactions (
  id                INT           NOT NULL AUTO_INCREMENT,
  user_id           INT           NOT NULL,
  category_id       INT           NOT NULL,
  amount            DECIMAL(15,2) NOT NULL,
  transaction_date  DATE          NOT NULL,
  note              VARCHAR(255)  NULL,
  created_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
                                  ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_transactions_user_date (user_id, transaction_date),
  KEY idx_transactions_category (category_id),
  KEY idx_transactions_date (transaction_date),
  CONSTRAINT chk_transactions_amount CHECK (amount > 0),
  CONSTRAINT fk_transactions_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_transactions_category
    FOREIGN KEY (category_id) REFERENCES categories (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- attachments: the receipt image of a transaction (zero or one each)
-- The image itself lives on Cloudinary; this table keeps its URL and
-- public_id. UNIQUE (transaction_id) allows at most one receipt per
-- transaction.
-- ON DELETE CASCADE removes this row with its transaction, but it does
-- NOT delete the image on Cloudinary. The backend must delete the
-- Cloudinary image (using public_id) before deleting the transaction.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS attachments (
  id              INT          NOT NULL AUTO_INCREMENT,
  transaction_id  INT          NOT NULL,
  file_name       VARCHAR(255) NOT NULL,
  file_url        VARCHAR(255) NOT NULL,
  public_id       VARCHAR(255) NOT NULL,
  mime_type       VARCHAR(50)  NOT NULL,
  file_size       INT          NOT NULL,
  uploaded_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_attachments_transaction (transaction_id),
  CONSTRAINT chk_attachments_mime
    CHECK (mime_type IN ('image/jpeg', 'image/png')),
  CONSTRAINT chk_attachments_size
    CHECK (file_size > 0 AND file_size <= 2097152),
  CONSTRAINT fk_attachments_transaction
    FOREIGN KEY (transaction_id) REFERENCES transactions (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;
