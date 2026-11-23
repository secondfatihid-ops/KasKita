-- =====================================================================
-- KasKita - initial data
-- Run after schema.sql. Uses INSERT IGNORE, so running it again will not
-- create duplicates.
-- =====================================================================

USE kaskita;

-- ---------------------------------------------------------------------
-- Roles
-- ---------------------------------------------------------------------
INSERT IGNORE INTO roles (id, name) VALUES
  (1, 'owner'),
  (2, 'staff');

-- ---------------------------------------------------------------------
-- Default categories
-- ---------------------------------------------------------------------
INSERT IGNORE INTO categories (name, type) VALUES
  ('Sales',                 'income'),
  ('Other Income',          'income'),
  ('Raw Materials',         'expense'),
  ('Salaries',              'expense'),
  ('Rent and Utilities',    'expense'),
  ('Transportation',        'expense'),
  ('Other Expenses',        'expense');

-- ---------------------------------------------------------------------
-- Test accounts (one per role, as required for the exam)
--
--   Owner : owner@kaskita.test / Owner123!
--   Staff : staff@kaskita.test / Staff123!
--
-- The passwords are stored as bcrypt hashes (cost 10, $2b$ format), which
-- work with the bcrypt and bcryptjs packages for Node.js.
-- These are TEST accounts only. Change or delete them before the system
-- is used with real business data.
-- ---------------------------------------------------------------------
INSERT IGNORE INTO users (role_id, name, email, password_hash) VALUES
  (
    (SELECT id FROM roles WHERE name = 'owner'),
    'KasKita Owner',
    'owner@kaskita.test',
    '$2b$10$2ckl.GtHZFdmz7UfvM.KduwW/T07u2ypk2coRJ/lvBkoKf8X4kL5O'
  ),
  (
    (SELECT id FROM roles WHERE name = 'staff'),
    'KasKita Staff',
    'staff@kaskita.test',
    '$2b$10$LkHWaEz3E3HSiOVW9DHXcOP4HqDIFfEevta.58ongwkaCxJmO0tXW'
  );
