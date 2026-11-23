# KasKita

**KasKita** is a cash book application for Micro, Small and Medium Enterprises (MSMEs). Owners and staff record income and expenses, attach receipt photos as proof, and see their balance and totals on a dashboard. It is available as an Android mobile app and as a web app.

Developed by [Student Name], [Student Class], [School Name] ([Year]).

## Status

| Part | Technology | Status |
|---|---|---|
| Database | MySQL | Schema and seed files done |
| Backend API | Node.js, Express.js | In development |
| Mobile app | Flutter | In development |
| Web app | Next.js | In development |
| Documentation | SRS | Draft done |

## Features

- Register, log in and log out (JWT authentication, passwords hashed with bcrypt)
- Two roles with different access: **Owner** and **Staff**
- Category management (income and expense categories), Owner only
- Add, view, edit and delete transactions, with confirmation before deleting
- Receipt image upload (JPG or PNG, up to 2 MB), stored on Cloudinary
- Dashboard with balance, total income and total expenses
- Input validation and clear success and error messages
- Optional: search and filter, monthly summary, user management by the Owner

### Roles

| Action | Owner | Staff |
|---|---|---|
| Record, edit and delete transactions | All transactions | Own transactions only |
| Upload and view receipts | Yes | Own transactions only |
| View dashboard summary | All data | Own data |
| Manage categories | Yes | No (view only) |
| Manage users (optional) | Yes | No |

Self-registration creates a Staff account. The Owner account is created by the seed file, and the Owner can change user roles.

## Tech stack

| Part | Technology | Hosting |
|---|---|---|
| Database | MySQL 8 | Aiven |
| Backend API | Node.js, Express.js (REST, JSON) | Vercel |
| Web app | Next.js | Vercel |
| Mobile app | Flutter (Android) | APK build |
| Image storage | Cloudinary | Cloudinary |
| Source control | Git, GitHub (feature branches) | GitHub |

## Project structure

```
KasKita/
├── backend/     # Node.js + Express REST API
├── database/    # SQL files (schema.sql, seed.sql)
├── web/         # Next.js web application
├── mobile/      # Flutter application (Android)
└── docs/        # SRS document and diagrams
```

## Database

The database has five tables: `roles`, `users`, `categories`, `transactions` and `attachments`. The full structure is in the ERD in the SRS document.

To set it up on a local MySQL 8.0.16 or newer (needed for the CHECK constraints):

```
cd database
mysql -u root -p
```

Then, inside the MySQL client:

```sql
source schema.sql;
source seed.sql;
```

`schema.sql` creates the `kaskita` database and its tables. `seed.sql` adds the roles, default categories and the test accounts below. Both files are safe to run more than once.

## Test accounts

These accounts are created by `seed.sql` for testing only. Change or delete them before using real business data.

| Role | Email | Password |
|---|---|---|
| Owner | owner@kaskita.test | Owner123! |
| Staff | staff@kaskita.test | Staff123! |

## Backend, web and mobile setup

Setup steps for these parts will be added as each one is built.

## Environment variables

Secrets are never committed to Git. Each part that needs them will have a `.env.example` file listing the names of the values to fill in (database connection, JWT secret and Cloudinary credentials). Copy it to `.env` and fill in your own values.

## Git workflow

The `main` branch holds the stable version. Each feature is built in its own branch, tested, and then merged into `main`:

- `feature/database`
- `feature/auth`
- `feature/categories`
- `feature/transactions`
- `feature/upload`
- `feature/flutter-app`
- `feature/web`

## Documentation

The Software Requirements Specification (SRS) is in the `docs/` folder: [link to be added].

## Deployment

| Part | Link |
|---|---|
| Web app | [link to be added] |
| Backend API | [link to be added] |
| Figma design | [link to be added] |
