# Online Complaint Management & Redressal Portal

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://adoptium.net)
[![Servlet](https://img.shields.io/badge/Jakarta_Servlet-6.0-blue.svg)](https://jakarta.ee)
[![Tomcat](https://img.shields.io/badge/Apache_Tomcat-10.1-yellow.svg)](https://tomcat.apache.org)
[![MongoDB Atlas](https://img.shields.io/badge/Database-MongoDB_Atlas-green.svg)](https://www.mongodb.com/atlas)
[![Build](https://img.shields.io/badge/Build-Maven-red.svg)](https://maven.apache.org)

An enterprise-grade, responsive **Online Complaint Management & Redressal Portal** engineered for the B.Tech 3rd-Year Advanced Java Programming curriculum. The system centralizes grievance registration, dispatches tamper-proof reference codes, maintains append-only lifecycle audit trails, and provides real-time administrative triage.

---

## 1. Technical Architecture & Design Pattern

The application strictly implements **Layered MVC (Model-View-Controller)** with complete separation of concerns:

```
[ Browser / Client ] 
        │
        ▼ (HTTP Requests / Form Data / CSRF Tokens)
[ Jakarta Filters ] ── AuthFilter, AdminFilter
        │
        ▼
[ Servlets / Controllers ] ── RegisterServlet, LoginServlet, ComplaintServlet, AdminComplaintServlet
        │
        ▼
[ Business Service Layer ] ── AuthService, ComplaintService
        │
        ▼
[ Data Access Objects (DAO) ] ── UserDao, ComplaintDao, ComplaintUpdateDao
        │
        ▼ (Official MongoDB Java Sync Driver)
[ MongoDB Atlas Database ] ── Collections: users, complaints, complaint_updates
```

- **Controller Layer:** Pure Java Servlets extending `HttpServlet` (`jakarta.servlet.*`).
- **View Layer:** JavaServer Pages (JSP) under `WEB-INF/views/` using JSTL and Institutional Trust design language.
- **Service Layer:** Business validation, BCrypt password hashing, reference number generation, and status transition rules.
- **DAO Layer:** Encapsulates all document queries, filters, updates, and indexes via the official MongoDB Java Sync Driver.
- **Connection Management:** Application-level singleton connection pool via `ServletContextListener` and `MongoConfig`.

---

## 2. Technology Stack

| Component | Technology | Version | Notes |
|---|---|---|---|
| **Language** | Java SE | JDK 17 (LTS) | Modern language features & records compatibility |
| **Web Container** | Apache Tomcat | 10.1.x | Jakarta EE 10 / Servlet 6.0 compatible |
| **Servlet API** | Jakarta Servlet | 6.0.0 | Pure `jakarta.servlet.*` namespace |
| **View Engine** | Jakarta Server Pages (JSP) + JSTL | 3.1 / 3.0 | Modern JSTL tags (`jakarta.tags.core`) |
| **Database** | MongoDB Atlas | 5.0+ Cloud Cluster | Document-oriented, scalable persistence |
| **Driver** | MongoDB Java Sync Driver | 5.1.4 | Official non-blocking/sync MongoDB driver |
| **Security** | jBCrypt | 0.4 | Salt rounds = 12 for strong password hashing |
| **UI Framework** | Bootstrap 5 + Institutional Trust CSS | 5.3.3 | Fully responsive for desktop, tablet, and mobile |
| **Build Tool** | Apache Maven | 3.9+ | Standard WAR artifact packaging |

---

## 3. MongoDB Atlas Database Design

The database is named `complaint_portal` and comprises 3 dedicated collections:

### Collection: `users`
| Field | Type | Description |
|---|---|---|
| `_id` | `ObjectId` | Primary key identifier |
| `fullName` | `String` | Complainant or administrator display name |
| `email` | `String` | Normalized lower-case email (**Unique Index**) |
| `passwordHash` | `String` | BCrypt password hash (never stores plain-text) |
| `role` | `String` | Role authorization: `USER` or `ADMIN` |
| `active` | `Boolean` | Account status flag |
| `createdAt` | `Date` | Timestamp of account registration |
| `updatedAt` | `Date` | Timestamp of last modification |

### Collection: `complaints`
| Field | Type | Description |
|---|---|---|
| `_id` | `ObjectId` | Primary key identifier |
| `referenceId` | `String` | Public reference code e.g. `CMP-20261011-8F2K` (**Unique Index**) |
| `userId` | `ObjectId` | Reference to complainant's user ID |
| `category` | `String` | Academic, Hostel, IT Services, Accounts, Transport, etc. |
| `subject` | `String` | High-level summary of grievance |
| `description` | `String` | Comprehensive grievance description |
| `status` | `String` | Lifecycle status: `SUBMITTED`, `UNDER_REVIEW`, `IN_PROGRESS`, `RESOLVED`, `REJECTED`, `CLOSED` |
| `adminRemark` | `String` | Latest official administrative resolution remark |
| `createdAt` | `Date` | Submission timestamp |
| `updatedAt` | `Date` | Last status modification timestamp |

### Collection: `complaint_updates` (Append-Only Audit History)
| Field | Type | Description |
|---|---|---|
| `_id` | `ObjectId` | Audit entry ID |
| `complaintId` | `ObjectId` | Linked complaint ID (**Indexed**) |
| `previousStatus` | `String` | Status before transition (or `null` upon submission) |
| `newStatus` | `String` | New status assigned |
| `remark` | `String` | Mandatory justification remark entered by officer |
| `changedBy` | `ObjectId` | User ID of the administrator executing change |
| `changedByName`| `String` | Full name of the acting officer |
| `changedAt` | `Date` | Exact timestamp of status transition |

---

## 4. Complaint Status Lifecycle

```
[ SUBMITTED ] ──────────► [ UNDER_REVIEW ] ──────────► [ IN_PROGRESS ]
      │                         │                            │
      ▼                         ▼                            ▼
  [ REJECTED ]              [ REJECTED ]                [ RESOLVED ]
                                                             │
                                                             ▼
                                                         [ CLOSED ]
```

1. **SUBMITTED:** Initial state automatically set upon grievance lodgment.
2. **UNDER_REVIEW:** Nodal desk has acknowledged and triaged the complaint.
3. **IN_PROGRESS:** Active physical or institutional remediation underway.
4. **RESOLVED:** Issue rectified with official resolution remarks.
5. **REJECTED:** Ineligible or duplicate grievance with required explanatory remark.
6. **CLOSED:** Final archival state.

---

## 5. Security & Protection Mechanisms

- **Password Encryption:** Passwords are hashed using BCrypt (cost factor 12).
- **Externalized Credentials:** Atlas connection strings are read from `MONGODB_URI` environment variables—never committed into code.
- **Session Authentication:** Role checks are enforced server-side inside `AuthFilter` and `AdminFilter`.
- **Ownership Verification:** Users cannot view complaints belonging to other users simply by changing URL parameters (`/complaints/view?id=...`).
- **CSRF Defense:** State-changing requests (`POST`) require a cryptographically generated session token.
- **Session Fixation Prevention:** Session IDs are regenerated upon successful authentication.

---

## 6. How to Set Up & Run the Project

### Prerequisites
1. **JDK 17** installed and configured in `JAVA_HOME`.
2. **Apache Maven 3.8+** installed.
3. **Apache Tomcat 10.1+** downloaded.
4. **MongoDB Atlas Account** (Free M0 cluster).

### Step 1: Configure MongoDB Atlas Cluster
1. Log in to [MongoDB Atlas](https://cloud.mongodb.com/).
2. Under **Network Access**, add your current IP address (or `0.0.0.0/0` for initial testing).
3. Under **Database Access**, create a database user (e.g., `admin_user` with a strong password).
4. Click **Connect** &rarr; **Drivers** &rarr; copy the connection string:
   ```
   mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```

### Step 2: Set Environment Variables
In Windows PowerShell:
```powershell
$env:MONGODB_URI="mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority"
$env:MONGODB_DATABASE="complaint_portal"
```

In Linux / macOS:
```bash
export MONGODB_URI="mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority"
export MONGODB_DATABASE="complaint_portal"
```

### Step 3: Build the Project
Open terminal in the project root and execute:
```bash
mvn clean package
```
This will compile the Java classes, run unit checks, and produce the deployable artifact:
`target/complaint-portal.war`

### Step 4: Deploy on Apache Tomcat 10.1
1. Copy `target/complaint-portal.war` into your Tomcat `webapps/` directory:
   ```bash
   cp target/complaint-portal.war /path/to/tomcat-10.1/webapps/
   ```
   *(Optionally rename to `ROOT.war` to serve at the root `/` URL).*
2. Start Tomcat:
   - Windows: `bin\startup.bat`
   - Linux/Mac: `bin/startup.sh`
3. Open your browser and navigate to:
   ```
   http://localhost:8080/complaint-portal/
   ```

---

## 7. Default Demonstration Credentials

The application auto-provisions a default administrator on startup if no admin account exists:

- **Admin Portal Email:** `admin@college.edu`
- **Admin Password:** `Admin@1234`
- **Admin Dashboard URL:** `http://localhost:8080/complaint-portal/admin/dashboard`

*(Students can register their own accounts directly via the **Register** link).*

---

## 8. College Project Viva / Evaluation Highlights

When presenting this project to professors and external examiners, highlight:
1. **Jakarta EE 10 Modern Standards:** Why `jakarta.servlet.*` was chosen over outdated `javax.servlet.*`.
2. **NoSQL vs Relational Schema:** How MongoDB documents naturally handle dynamic complaint descriptions and nested audit history.
3. **Defense-in-Depth Security:** BCrypt salt rounds, CSRF tokens, session fixation mitigation, and server-side ownership authorization.
4. **Append-Only Event Sourcing Pattern:** Why status updates are recorded in `complaint_updates` rather than simply mutating the current status in-place.
