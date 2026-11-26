# SOFTWARE REQUIREMENTS SPECIFICATION (SRS)

# KASKITA – MSME CASH BOOK APPLICATION

Compiled by: \[Student Name\] · \[Student Class\] · \[School Name\] · \[School Address\] · \[Year\]

## FOREWORD

The author expresses gratitude to God Almighty, whose grace made it possible to complete this Software Requirements Specification (SRS) on time.

This document is titled **"KasKita – MSME Cash Book Application"** and was compiled as part of the Software Engineering (RPL) competency assessment at \[School Name\]. KasKita is a web and mobile financial recording system that helps Micro, Small and Medium Enterprise (MSME) owners record income and expenses, attach receipt photos, and monitor their cash flow in a structured way.

The author thanks everyone who gave guidance, support and input while this document and the project were being prepared. The author realizes this document still has room for improvement, so suggestions are welcome. It is hoped that this document gives a clear picture of the system to be built and that KasKita brings real benefits to MSME owners.

&#91;City\], \[Date\] \[Month\] \[Year\]

&#91;Student Name\]

## TABLE OF CONTENTS

- Foreword
- Chapter I – Introduction: 1.1 Background · 1.2 Problem Formulation · 1.3 System Development Objectives and Purpose of the Document
- Chapter II – Development Methods: 2.1 Software Development Method (Agile) · 2.2 System Development Schedule · 2.3 Data Collection Methods
- Chapter III – System Requirements Analysis: 3.1 System Name · 3.2 System Scope · 3.3 Functional Requirements · 3.4 Non-Functional Requirements · 3.5 System Limitations · 3.6 SWOT Analysis
- Chapter IV – Development: 4.1 Project Management · 4.2 System Design (UML) · 4.3 Database Design · 4.4 Project Structure · 4.5 Display Design (UI/UX) · 4.6 Quality Assurance (Black Box Testing) · 4.7 Deployment
- Chapter V – Closing: 5.1 Conclusion · 5.2 Attachments

## CHAPTER I – INTRODUCTION

### 1.1 Background

Micro, Small and Medium Enterprises (MSMEs) are the backbone of the economy, but many owners still record their finances in paper notebooks or not at all. This manual recording often leads to lost or incomplete records, calculation errors, mixed-up personal and business money, and receipts that are misplaced or faded. Owners then struggle to know their real profit, and employees who handle cash are hard to monitor.

**KasKita** is designed as a web and mobile cash book application. Owners and staff can record income and expenses in one place, attach photos of receipts as proof, and see the balance and a summary of cash flow. The system provides user authentication, role-based access, category management, transaction management and image upload, so financial records stay organized and easy to monitor.

### 1.2 Problem Formulation

- a. How can a financial recording system be designed that is simple enough for MSME owners to use on mobile and web?
- b. How can a system be built that makes recording income and expenses, with receipt evidence, faster and more reliable?
- c. How can access be separated between owners and staff so financial data stays secure and organized?
- d. How can the system present balances and summaries so owners can monitor their business finances?

### 1.3 System Development Objectives and Purpose of the Document

**System development objectives:**

- a. Help MSME owners record income and expenses digitally and consistently.
- b. Store financial data and receipt images in a structured, secure and easily retrieved form.
- c. Provide a summary of balance, total income and total expenses.
- d. Restrict access by role so staff only see and manage what they are allowed to.
- e. Reduce the errors and data loss that occur in manual bookkeeping.

**Purpose of the document:** this SRS describes the requirements, design and implementation of KasKita. It serves as a reference for the developer, the examiner and future maintainers, and ensures that the system built matches what was planned.

## CHAPTER II – DEVELOPMENT METHODS

### 2.1 Software Development Method (Agile)

KasKita is developed with the **Agile** method. Agile is chosen because it builds the system in short iterations, so each finished feature can be tested and improved before the next begins. This matches the **feature-branch workflow** in GitHub: each feature is developed in its own branch, tested, and merged into the main branch when it is finished. Because the project has a short deadline, each day of the schedule is treated as one iteration.

#### a. Plan

The problems of manual bookkeeping are identified, the main features are listed (authentication, categories, transactions, receipt upload, dashboard), and the technology is chosen: Node.js with Express.js for the REST API, MySQL on Aiven for the database, Flutter for the mobile app, Next.js for the web app, Cloudinary for image storage, and Vercel for hosting.

#### b. Design

The system flow, database structure, table relationships and role-based access rights are designed. UML diagrams (use case, activity, class), the ERD and the UI/UX mockups are produced in this stage.

#### c. Develop

The design is implemented iteratively: database and migrations first, then the REST API, then the Flutter application, then the Next.js web application. Each feature lives in its own Git branch (for example `feature/auth`, `feature/transactions`, `feature/upload`) and is merged into `main` after testing.

#### d. Testing

The API is tested with Postman, and the mobile and web applications are tested directly through black box testing. Tests cover login, CRUD, upload validation and role restrictions.

#### e. Deploy

The database is deployed on Aiven, the backend API and the Next.js web application are deployed as two projects on Vercel, and images are stored on Cloudinary. The Flutter mobile app is built as an Android APK that connects to the deployed API.

#### f. Review

The finished system is evaluated against the requirements, and shortcomings are recorded as input for further improvement.

### 2.2 System Development Schedule

The project is completed in five days. Each day is one Agile iteration.

| Activity | Day 1 | Day 2 | Day 3 | Day 4 | Day 5 |
| --- | --- | --- | --- | --- | --- |
| Requirements analysis and SRS (Chapters I–III) | ■ |  |  |  |  |
| UML diagrams, ERD and UI/UX design | ■ |  |  |  |  |
| GitHub repository, Aiven database and migrations | ■ |  |  |  |  |
| Backend: authentication and roles | ■ | ■ |  |  |  |
| Backend: categories, transactions, validation |  | ■ |  |  |  |
| Backend: Cloudinary receipt upload |  | ■ |  |  |  |
| API deployment on Vercel and Postman testing |  | ■ |  |  |  |
| Flutter mobile application |  |  | ■ |  |  |
| Next.js web application and deployment |  |  |  | ■ |  |
| Integration and bug fixing |  |  |  | ■ |  |
| Black box testing and evidence |  |  |  |  | ■ |
| Final SRS (structure, deployment, UI chapters) |  |  |  |  | ■ |
| Test accounts and presentation rehearsal |  |  |  |  | ■ |

Start date: \[date\]. End date: \[date\].

### 2.3 Data Collection Methods

#### a. Observation

The author observes how small businesses nearby (for example \[type of shop/stall\]) record their income and expenses. Typical problems are handwritten notes that get lost, no record of receipts, and difficulty calculating daily and monthly totals.

#### b. Interview

The author interviews \[number\] MSME owners or staff about how they record money, what problems they face, and which features they need, such as categories, receipt photos and a monthly summary. The answers are the basis for the KasKita features.

*(Replace this section with your real observation and interview results.)*

## CHAPTER III – SYSTEM REQUIREMENTS ANALYSIS

### 3.1 System Name

**KasKita** – a cash book application for recording MSME income and expenses.

### 3.2 System Scope

KasKita is a web and mobile application that digitizes the cash recording process of MSMEs. It lets owners and staff record transactions with receipt evidence and lets owners monitor the financial condition of the business at any time.

#### a. System Platform

| Part | Technology | Hosting |
| --- | --- | --- |
| Database | MySQL | Aiven |
| Backend API | Node.js and Express.js (REST, JSON) | Vercel |
| Web application | Next.js | Vercel |
| Mobile application | Flutter (Android) | APK build |
| Image storage | Cloudinary | Cloudinary |
| Authentication | JWT, passwords hashed with bcrypt | – |
| Source control | GitHub with feature branches | GitHub |

#### b. Types of System Users

1. **Owner:** manages categories and all transactions, views summaries, and manages staff accounts.
2. **Staff:** records transactions and views and manages only their own transactions.

#### c. Main System Features

1. Registration, login and logout with JWT authentication.
2. Category management (income and expense categories).
3. Transaction management (add, view, edit, delete) with confirmation on delete.
4. Receipt image upload to Cloudinary and display, with type and size validation.
5. Dashboard with balance, total income and total expenses.
6. *Optional:* search and filter by date range, category and type, and a monthly summary.
7. *Optional:* user management by the Owner (view users, change role, activate or deactivate).

#### d. System Benefits

For owners, KasKita provides accurate and organized financial records, receipt proof for every transaction, and a quick view of profit and cash flow. For staff, it makes daily recording fast and clear. For the business as a whole, data is stored digitally, can be accessed from anywhere, and is protected by role-based access.

### 3.3 Functional Requirements

#### a. User Characteristics

| User | Description | Technical skill |
| --- | --- | --- |
| Owner | Business owner who monitors finances and manages categories and staff | Basic smartphone and web use |
| Staff | Employee who records daily transactions | Basic smartphone use |

Self-registration creates a Staff account. The Owner account is created in advance (seeded), and the Owner can change user roles.

#### b. Functional Requirements

| ID | Requirement | Role | Priority |
| --- | --- | --- | --- |
| FR-01 | The system shall allow users to register with name, email and password. | All | Must |
| FR-02 | The system shall authenticate users by email and password and issue a token. | All | Must |
| FR-03 | The system shall store passwords only in hashed form. | System | Must |
| FR-04 | The system shall restrict endpoints and screens according to user role. | System | Must |
| FR-05 | The system shall allow the Owner to create, view, edit and delete categories. | Owner | Must |
| FR-06 | The system shall allow users to create transactions (amount, category, date, note). | Owner, Staff | Must |
| FR-07 | The system shall display a transaction list and transaction details. | Owner, Staff | Must |
| FR-08 | The system shall allow users to edit and delete transactions, with confirmation before deleting. | Owner, Staff | Must |
| FR-09 | Staff shall only access their own transactions; the Owner can access all. | System | Must |
| FR-10 | The system shall allow users to upload a receipt image (JPG/PNG, maximum 2 MB) stored on Cloudinary. | Owner, Staff | Must |
| FR-11 | The system shall display the uploaded receipt in the transaction detail. | Owner, Staff | Must |
| FR-12 | The system shall display balance, total income and total expenses. | Owner, Staff | Must |
| FR-13 | The system shall validate all input on the backend and the client and show success or error messages. | System | Must |
| FR-14 | The system shall allow search and filtering by date, category and type, and show a monthly summary. | Owner, Staff | Optional |
| FR-15 | The system shall allow the Owner to manage user accounts and roles. | Owner | Optional |

#### c. Data Dictionary

**roles**

| Attribute | Type | Description |
| --- | --- | --- |
| id | INT (PK) | Role identifier |
| name | VARCHAR(30) | Role name (owner, staff) |

**users**

| Attribute | Type | Description |
| --- | --- | --- |
| id | INT (PK) | User identifier |
| role\_id | INT (FK → roles) | User's role |
| name | VARCHAR(100) | Full name |
| email | VARCHAR(100) | Unique login email |
| password\_hash | VARCHAR(255) | Hashed password |
| is\_active | TINYINT(1) | Account status |
| created\_at / updated\_at | DATETIME | Record timestamps |

**categories**

| Attribute | Type | Description |
| --- | --- | --- |
| id | INT (PK) | Category identifier |
| name | VARCHAR(60) | Category name (e.g., Sales, Supplies) |
| type | ENUM('income','expense') | Category type |
| created\_at | DATETIME | Creation time |

**transactions**

| Attribute | Type | Description |
| --- | --- | --- |
| id | INT (PK) | Transaction identifier |
| user\_id | INT (FK → users) | User who recorded it |
| category\_id | INT (FK → categories) | Transaction category |
| amount | DECIMAL(15,2) | Transaction amount |
| transaction\_date | DATE | Date of the transaction |
| note | VARCHAR(255) | Optional description |
| created\_at / updated\_at | DATETIME | Record timestamps |

**attachments**

| Attribute | Type | Description |
| --- | --- | --- |
| id | INT (PK) | Attachment identifier |
| transaction\_id | INT (FK → transactions) | Related transaction |
| file\_name | VARCHAR(255) | Original file name |
| file\_url | VARCHAR(255) | Cloudinary image URL |
| public\_id | VARCHAR(255) | Cloudinary identifier, used to delete the image |
| mime\_type | VARCHAR(50) | File type |
| file\_size | INT | Size in bytes |
| uploaded\_at | DATETIME | Upload time |

#### d. User Interface

The main screens are: Login, Register, Dashboard, Transaction List, Transaction Detail, Add/Edit Transaction (with receipt upload), Category Management (Owner), User Management (Owner, optional) and Profile. Mockups are in section 4.5.

#### e. Interaction Between Modules

| Module | Endpoints (examples) | Access |
| --- | --- | --- |
| Auth | POST /auth/register, POST /auth/login | Public |
| Users | GET /users, PATCH /users/:id | Owner |
| Categories | GET, POST, PUT, DELETE /categories | GET: all; changes: Owner |
| Transactions | GET, POST, PUT, DELETE /transactions | Owner, Staff (own data) |
| Receipts | POST /transactions/:id/attachment | Owner, Staff |
| Summary | GET /summary | Owner, Staff (own data for Staff) |

The Flutter and Next.js clients send requests with a JWT in the header. The authentication middleware verifies the token, the role middleware checks access rights, validators check the input, and the controller reads or writes MySQL and returns a consistent JSON response with the proper HTTP status code. For receipts, the API receives the image in memory, validates its type and size, uploads it to Cloudinary, and saves the returned URL in the database.

#### f. Business Flow

1. A user registers and logs in; the system returns a token.
2. The user opens the dashboard and sees the balance and totals.
3. The user adds a transaction, choosing a category, amount, date and note, and optionally uploads a receipt.
4. The system validates the input, uploads the image to Cloudinary and saves the data to the database.
5. The user can view, edit or delete transactions (and search or filter, if implemented).
6. The Owner manages categories and staff accounts and monitors all transactions.

### 3.4 Non-Functional Requirements

#### a. Product Requirements

- **Performance:** common operations (login, saving a transaction, loading a list) should respond within a few seconds on a normal connection.
- **Security:** hashed passwords, JWT authentication, role-based authorization, input validation and protected private endpoints.
- **Usability:** a simple, clean interface that is easy to use on phones and in the browser.
- **Reliability:** data is stored in the database and receipts on Cloudinary, and errors are handled with clear messages.
- **Maintainability:** a modular code structure so features can be added later.

#### b. Organizational Requirements

- The project is completed individually within five days.
- The source code is stored on GitHub, with one branch per feature.
- Development follows the Agile method and the SRS structure given by the school.

#### c. External Requirements

- Uploaded files are limited to JPG/PNG and 2 MB for storage and security reasons.
- Users' financial data must only be accessible according to their role (privacy).
- The system must run on the platforms chosen for the project: Vercel, Aiven and Cloudinary.

### 3.5 System Limitations

#### a. Technology Limitations

1. The system is built with Express.js, MySQL, Next.js and Flutter.
2. An internet connection is required to use the application.
3. Authentication uses JWT.
4. Images are stored on Cloudinary, so uploads depend on that service being available.

#### b. Platform Limitations

1. The mobile app targets Android smartphones; the web application runs in modern browsers such as Chrome and Edge.
2. The display is responsive but may differ depending on screen size.

#### c. Regulatory Limitations

1. Users must log in before accessing the main features.
2. Data can only be accessed according to the user's role.
3. KasKita is a recording tool; it is not an accounting or tax-reporting system and is not integrated with banks or payment gateways.

### 3.6 SWOT Analysis

- **a. Strengths:** available on mobile and web; simple recording process; receipt evidence; role-based access; structured digital storage.
- **b. Weaknesses:** requires an internet connection; no offline mode; users unfamiliar with technology may need time to adapt; maintaining web and mobile versions takes more effort.
- **c. Opportunities:** many MSMEs still record manually; the system can be extended with reports, notifications, export to PDF or Excel, and multi-business support.
- **d. Threats:** data security risks such as unauthorized access; competition from existing finance apps; server or network disruptions.

## CHAPTER IV – DEVELOPMENT

### 4.1 Project Management

Project tasks are managed on a board: **\[Trello / GitHub Projects link\]**.

The source code is stored in **\[GitHub repository link\]** with this branching strategy:

- `main`: stable, deployed version.
- `feature/*`: one branch per feature, such as `feature/database`, `feature/auth`, `feature/categories`, `feature/transactions`, `feature/upload`, `feature/flutter-app` and `feature/web`. Each is merged into `main` after testing.

### 4.2 System Design (UML)

#### a. Use Case Diagram

&#91;embedded content: use case diagram · 2 actors, 8 use cases\]

Staff and Owner both log in, record transactions, upload receipts and view the dashboard. Only the Owner manages categories, users and sees every transaction.

#### b. Activity Diagram

The three main flows are shown below, with the checks that stop an invalid request.

**Login**

&#91;embedded content: activity diagram · login, 2 decisions\]

**Record a transaction**

&#91;embedded content: activity diagram · record a transaction, 2 decisions\]

**Upload a receipt**

&#91;embedded content: activity diagram · upload a receipt, 3 decisions\]

#### c. Class Diagram

&#91;embedded content: class diagram · 5 classes, 4 associations\]

The classes mirror the five tables and add the main actions each one supports.

### 4.3 Database Design

#### a. Entity Relationship Diagram (ERD)

**Chen notation**

&#91;embedded content: ERD, Chen notation · 5 entities, 4 relationships\]

**Crow's foot notation**

&#91;embedded content: ERD · 5 tables, 4 relationships\]

Relationships:

- One role has many users (roles 1 : N users).
- One user records many transactions (users 1 : N transactions).
- One category groups many transactions (categories 1 : N transactions).
- One transaction has zero or one receipt attachment (transactions 1 : 0..1 attachments).

#### b. Table Schema and MySQL Implementation

The columns are described in the data dictionary (section 3.3.c). The key integrity rules are:

| Table | Primary key | Foreign keys | Other constraints |
| --- | --- | --- | --- |
| roles | id | none | name unique |
| users | id | role\_id → roles.id | email unique |
| categories | id | none | type limited to income or expense |
| transactions | id | user\_id → users.id; category\_id → categories.id | amount must be greater than 0 |
| attachments | id | transaction\_id → transactions.id | one attachment per transaction; removed together with its transaction |

&#91;Insert SQL / migration file reference after implementation.\] The transaction type (income or expense) comes from its category, so it is not stored twice.

### 4.4 Project Structure

```
kaskita/
├── backend/            # Node.js + Express REST API (Vercel project 1)
│   └── src/
│       ├── config/         # database, Cloudinary and environment settings
│       ├── routes/         # endpoint definitions
│       ├── controllers/    # request handling logic
│       ├── middleware/     # authentication, role check, upload, errors
│       ├── validators/     # input validation
│       └── utils/          # helpers (responses, tokens)
├── database/           # SQL / migration files
├── web/                # Next.js web application (Vercel project 2)
├── mobile/             # Flutter application (Android)
│   └── lib/
│       ├── models/
│       ├── services/       # API calls
│       ├── screens/
│       ├── widgets/
│       └── providers/      # state and session management
└── docs/               # SRS and diagrams
```

(Adjust this to match your final folder layout.)

### 4.5 Display Design (UI/UX)

Design link: **\[Figma link\]**

#### a. Mobile View

Login, Register, Dashboard, Transaction List, Transaction Detail, Add/Edit Transaction, Category Management and Profile. \[Insert screenshots\]

#### b. Web View

Login, Dashboard, Transaction List, Add/Edit Transaction and receipt upload. \[Insert screenshots\]

### 4.6 Quality Assurance (Black Box Testing)

The test cases are run on the mobile and web applications. Actual results and status are filled in after testing.

| No | Test Case ID | Feature | Scenario | Input | Expected Result | Actual Result | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | TC\_REGIS\_001 | Register | Valid data | Name, unique email, password | Account created | \[fill in\] | \[ \] |
| 2 | TC\_REGIS\_002 | Register | Email already used | Registered email | Error message shown | \[fill in\] | \[ \] |
| 3 | TC\_REGIS\_003 | Register | Empty fields | Empty name or password | Registration rejected | \[fill in\] | \[ \] |
| 4 | TC\_LOGIN\_001 | Login | Correct credentials | Valid email and password | Logged in, dashboard shown | \[fill in\] | \[ \] |
| 5 | TC\_LOGIN\_002 | Login | Wrong password | Valid email, wrong password | Error message shown | \[fill in\] | \[ \] |
| 6 | TC\_LOGIN\_003 | Login | Unregistered email | Unknown email | Login failed | \[fill in\] | \[ \] |
| 7 | TC\_TRANS\_001 | Add transaction | Valid data | Category, amount, date, note | Transaction saved | \[fill in\] | \[ \] |
| 8 | TC\_TRANS\_002 | Add transaction | Invalid data | Empty or negative amount | Rejected with validation message | \[fill in\] | \[ \] |
| 9 | TC\_TRANS\_003 | Edit transaction | Change amount or note | New data | Data updated | \[fill in\] | \[ \] |
| 10 | TC\_TRANS\_004 | Delete transaction | Confirm deletion | Tap delete, then confirm | Transaction removed | \[fill in\] | \[ \] |
| 11 | TC\_UPLOAD\_001 | Upload receipt | Valid image | JPG under 2 MB | Uploaded and displayed | \[fill in\] | \[ \] |
| 12 | TC\_UPLOAD\_002 | Upload receipt | Wrong file type | PDF or other type | Rejected with error | \[fill in\] | \[ \] |
| 13 | TC\_UPLOAD\_003 | Upload receipt | File too large | Image over 2 MB | Rejected with error | \[fill in\] | \[ \] |
| 14 | TC\_ROLE\_001 | Authorization | Staff views another user's transaction | Request for another user's data | Access denied (403) | \[fill in\] | \[ \] |
| 15 | TC\_ROLE\_002 | Authorization | Staff creates a category | Category data | Access denied (403) | \[fill in\] | \[ \] |
| 16 | TC\_ROLE\_003 | Authorization | Owner creates a category | Category data | Category created | \[fill in\] | \[ \] |
| 17 | TC\_AUTH\_001 | Protected endpoint | No token | Request without token | Rejected (401) | \[fill in\] | \[ \] |
| 18 | TC\_DASH\_001 | Dashboard | View summary | Open dashboard | Correct balance and totals shown | \[fill in\] | \[ \] |
| 19 | TC\_LOGOUT\_001 | Logout | Tap logout | Click logout | Session ended, back to login | \[fill in\] | \[ \] |

Optional features (search, filter, monthly summary, user management) get their own test cases if they are implemented. Add a screenshot table for each test case.

### 4.7 Deployment

1. **Database (Aiven):** a MySQL service is created on Aiven, the structure is created from the SQL or migration files, and the connection details are kept as environment variables (Aiven typically requires an SSL connection). \[Insert screenshot\]
2. **Image storage (Cloudinary):** a Cloudinary account is created and its credentials are stored as environment variables of the backend. \[Insert screenshot\]
3. **Backend API (Vercel):** the Express.js API is deployed as a Vercel project with environment variables for the database, JWT secret and Cloudinary, and CORS allows the web application to call it. \[Insert URL and screenshot\]
4. **Web application (Vercel):** the Next.js application is deployed as a second Vercel project and points to the deployed API. \[Insert URL and screenshot\]
5. **Mobile application:** the Flutter app is built as an Android APK that uses the deployed API. \[Insert screenshot\]
6. **Version control (GitHub):** each feature is developed in a feature branch and merged into `main`, from which Vercel deploys. \[Insert repository link\]

## CHAPTER V – CLOSING

### 5.1 Conclusion

KasKita was designed as a digital solution that helps MSME owners record income and expenses in a more organized, accurate and accessible way. Through its web and mobile applications, users can record transactions, attach receipt evidence and monitor balances, while role-based access keeps financial data secure. The system uses Express.js, MySQL, Next.js and Flutter, stores receipts on Cloudinary, and is developed with the Agile method using feature branches.

This document is the basis for building a system that fits user needs. The author welcomes suggestions to improve both this document and the application.

### 5.2 Attachments

- GitHub repository link: \[link\]
- Deployed web application link: \[link\]
- Deployed API link: \[link\]
- Figma design link: \[link\]
- Test accounts (Owner and Staff): \[email / password\]
- UI/UX screenshots, diagrams and test evidence
