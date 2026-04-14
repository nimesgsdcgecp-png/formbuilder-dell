# 📋 FormBuilder3

**Enterprise-grade dynamic form builder with PostgreSQL backing.**

Powerful form management system with **automatic database generation, intelligent rule engines, and workflow approvals**.

---

## 🌟 Main Highlighting Features

### ⚡ **Automatic PostgreSQL Table Generation**
When you publish a form, FormBuilder3 **automatically creates a PostgreSQL table** to store responses. No manual database setup needed!
- Tables named: `sub_form_{formId}_v{version}`
- Columns automatically created from form fields
- Type-safe data storage
- Indexed for performance

### 🧠 **Intelligent Rule Engine**
Define **IF-THEN conditional logic** without writing a single line of code:
- Auto-show/hide fields based on user input
- Enable/disable fields conditionally
- Cross-field validation
- Evaluated **both client-side** (instant feedback) and **server-side** (data integrity)
- 6+ operators: equals, greaterThan, contains, startsWith, etc.

### 🔄 **Workflow & Approval System**
Transform forms into **approval workflows**:
- Initiate multi-step approval chains
- Route to specific authorities
- Track approval status in real-time
- Comments and feedback from approvers
- Complete audit trail of all decisions
- Perfect for compliance and governance

### 📋 **Form Versioning**
Every publish creates an **immutable snapshot**:
- Old submissions stay with their original schema
- Schema changes don't break past data
- Activate/deactivate versions anytime
- Maintain backward compatibility
- Complete change history

### 🔐 **Enterprise Security**
Built with security at every layer:
- Session-based authentication with BCrypt hashing
- Role-based access control (ADMIN, MENTOR, INTERN)
- SQL injection prevention (parameterized queries)
- Server-side validation and rule re-evaluation
- CSRF protection with SameSite cookies
- Complete audit logging of all changes

### 📤 **Public Form Sharing**
Share forms **without authentication**:
- Generate unique public links
- Anonymous submissions
- Work perfectly for customer feedback, surveys, applications
- No login barrier for respondents

---

## ⚡ Quick Start

```bash
# 1. Create database and setup schema
psql -U postgres -c "CREATE DATABASE formbuilder2;"
psql -U postgres formbuilder2 < sql/schema.sql
psql -U postgres formbuilder2 < sql/seeder.sql

# 2. Start backend
cd formbuilder-backend1
./mvnw spring-boot:run

# 3. Start frontend (new terminal)
cd formbuilder-frontend1
npm install && npm run dev

# 4. Open browser & login
# Frontend: http://localhost:3000
# API Docs: http://localhost:8080/swagger-ui.html
# Login: admin / admin123
```

**Done in 5 minutes!** → [Detailed setup guide](./README.md#-quick-start)

---

## ✨ Complete Feature Set

- **🎨 Visual Builder:** Drag-and-drop canvas with 30+ field types
- **📊 Dynamic Tables:** Automatic PostgreSQL table creation on publish
- **🎯 Rule Engine:** Visual IF-THEN conditional logic
- **🔄 Workflows:** Multi-step approval chains with tracking
- **📝 Form Versioning:** Immutable snapshots—old submissions stay with their schema
- **🔐 Security:** Role-based access, session management, SQL injection prevention
- **📤 Public Sharing:** Share forms with unique links—no login required
- **📋 Audit Trail:** Track all changes, submissions, and approvals
- **💡 Real-time Preview:** See changes instantly in builder
- **📝 Status Model:** Clear distinction between `DRAFT` forms and `RESPONSE_DRAFT` submissions
- **👥 User Management:** Admin controls for users and roles
- **📊 Response Analytics:** Export to CSV, filter, search, bulk actions

---

## 🏛️ Status Nomenclature
> [!NOTE]
> To ensure clarity in operational data, the system distinguishes between form states and submission states:
> - **Form `DRAFT`**: A form being built but not yet published.
> - **Submission `RESPONSE_DRAFT`**: A user's work-in-progress response (saved progress).
> - **Submission `SUBMITTED`**: A finalized and locked user response.

---

## 🏗️ Architecture

```
Frontend (Next.js)         Backend (Spring Boot)       Database (PostgreSQL)
─────────────────          ──────────────────         ─────────────────────
Form Builder UI      →     REST API & Services   →    Metadata Tables
Drag-Drop Canvas     →     Rule Engine           →    Dynamic Submission Tables
Zustand State Store  ←     Validation Logic      ←    (sub_form_X_vY)
```

**Key Principle:** Forms are versioned snapshots. Every publish creates an actual database table.

→ [See full architecture diagram](./ARCHITECTURE.md)

---

## 📚 Documentation

| Document | Read Time | For | Link |
|----------|-----------|-----|------|
| **[Frontend README](./formbuilder-frontend1/README.md)** | 10 min | Frontend features, components, state management | Frontend-specific developers |
| **[Backend README](./formbuilder-backend1/README.md)** | 10 min | Backend features, API endpoints, services | Backend-specific developers |
| **[SQL README](./sql/README.md)** | 5 min | Database setup, seed data, structure | DevOps, DB administrators |
| **[ARCHITECTURE.md](./ARCHITECTURE.md)** | 15 min | System design, data flows, tech stack | Understanding system design |
| **[DOCUMENTATION_GUIDE.md](./DOCUMENTATION_GUIDE.md)** | 5 min | Which doc to read? | Navigation and guidance |
| **[SECURITY_AUDIT.md](./SECURITY_AUDIT.md)** | 15 min | Security hardening, compliance | Production deployment |
| **[TESTING_GUIDE.md](./TESTING_GUIDE.md)** | 10 min | Testing strategy, test coverage | QA and testing |

**First time?** → Start with [Quick Start](#-quick-start) above, then read [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## 📂 Project Structure

```
FormBuilder3/
├── README.md                           ← You are here (Main overview)
├── ARCHITECTURE.md                     ← System design & data flows
├── DOCUMENTATION_GUIDE.md              ← Documentation navigation
├── SECURITY_AUDIT.md                   ← Security & hardening
├── TESTING_GUIDE.md                    ← Testing guide
│
├── sql/                                ← Database setup (NEW!)
│   ├── README.md                       ← SQL usage guide
│   ├── schema.sql                      ← Create all tables
│   ├── seeder.sql                      ← Populate test data
│   ├── mock_users_seeder.sql           ← Additional test users
│   └── unseed.sql                      ← Clear all data
│
├── formbuilder-frontend1/              ← React/Next.js Frontend
│   ├── README.md                       ← Frontend features & structure
│   ├── src/                            ← Source code
│   ├── package.json                    ← Dependencies
│   └── next.config.ts                  ← Next.js config
│
└── formbuilder-backend1/               ← Spring Boot Backend
    ├── README.md                       ← Backend features & APIs
    ├── src/main/java/                  ← Source code
    ├── pom.xml                         ← Maven dependencies
    └── application.properties          ← Configuration
```

---

## 🛠️ Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **Frontend** | Next.js + React | 16.1.6 + 19.2 |
| **Backend** | Spring Boot + Java | 3.5.11 + 21 |
| **Database** | PostgreSQL | 14+ |
| **State Mgmt** | Zustand | 5.0.11 |
| **Styling** | Tailwind CSS | 4.2.1 |
| **Auth** | Spring Security | Latest |

---

## 📈 Project Stats

- **100+** Backend classes
- **20+** Frontend components
- **50+** API endpoints
- **16** Database entities
- **30+** Field types supported

---

## 🚀 Use Case Example

**Build a Customer Feedback Form**

```
1. Click "Create Form"
2. Add fields: Name, Email, Rating, Comments
3. Add rule: "If rating < 3, show escalation field"
4. Click "Publish"
5. Share public link → /f/{token}
6. Customers fill form
7. Database automatically stores responses
8. View responses in admin panel
```

Done! Form collects data, validates input, and stores in PostgreSQL. No custom backend needed.

---

## 🔐 Security

- ✅ Session-based authentication (JSESSIONID)
- ✅ Password hashing with BCrypt
- ✅ SQL injection prevention (parameterized queries)
- ✅ Role-based access control
- ✅ Server-side rule validation
- ⚠️ See [SECURITY_AUDIT.md](./SECURITY_AUDIT.md) for production hardening

---

## 🎓 How It Works

### Form Publication Flow
```
Draft Form
    ↓ (click "Publish")
Validate schema
    ↓
Create database table (sub_form_X_vY)
    ↓
Form published & added to public link
    ↓
Ready for submissions
```

### Submission Flow
```
User fills form
    ↓
Frontend validates
    ↓ (submit)
Backend validates + re-evaluates rules
    ↓
INSERT into database table
    ↓
Response stored with exact schema version
```

→ [See detailed flows](./ARCHITECTURE.md#-how-it-works-form-publication)

---

## 📋 System Model

```
FORMS (form metadata)
  ├─ FORM_VERSIONS (versioned snapshots)
  │  ├─ FORM_FIELDS (field definitions)
  │  └─ Rules (JSON)
  └─ Dynamic Tables (sub_form_1_v1, sub_form_1_v2, etc.)

DATA (submissions)
  └─ Dynamic submission tables created on publish
```

---

## 🔗 API Example

### Create & Publish Form
```bash
# Create
curl -X POST http://localhost:8080/api/v1/forms \
  -H "Content-Type: application/json" \
  -d '{"title":"Feedback","code":"feedback_form"}'

# Publish
curl -X POST http://localhost:8080/api/v1/forms/1/publish

# Get public link
# /f/{shareToken}
```

### Submit Response
```bash
curl -X POST http://localhost:8080/api/v1/runtime/submit \
  -H "Content-Type: application/json" \
  -d '{
    "formId": 1,
    "fieldValues": {
      "name": "John",
      "rating": 5,
      "comment": "Great service!"
    }
  }'
```

→ [See all API endpoints](./DOCUMENTATION.md)

---

## 🚀 Deployment

### Development
```bash
mvn spring-boot:run        # Backend on :8080
npm run dev                # Frontend on :3000
```

### Production
```bash
# Build backend
mvn clean package
java -jar target/formbuilder2-0.0.1-SNAPSHOT.jar

# Build frontend
npm run build
npm start
```

→ [Detailed deployment guide](./IMPLEMENTATION_GUIDE.md#-deployment-production)

---

## ❓ FAQ

**Q: Can I change the database?**
A: PostgreSQL is strongly recommended. The codebase uses PostgreSQL-specific features.

**Q: How do I backup my data?**
A: Use PostgreSQL backup: `pg_dump -U postgres formbuilder2 > backup.sql`

**Q: Can users modify published forms?**
A: No, published forms are immutable. Create a new version to make changes.

**Q: Is it scalable?**
A: Yes. Backend is stateless and can be horizontally scaled. Ensure PostgreSQL can handle your load.

**Q: How many fields per form?**
A: Max 50 fields per form (configurable in `application.properties`).

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Backend won't start | Ensure PostgreSQL is running and database exists |
| Can't connect frontend to backend | Check API URL in `src/services/api.ts` |
| Form won't publish | Check all fields have valid types and names |
| Database shows error on startup | Run: `psql -U postgres -c "CREATE DATABASE formbuilder2;"` |

→ [Full troubleshooting guide](./IMPLEMENTATION_GUIDE.md#-troubleshooting)

---

## 📞 Getting Help

1. Check [DOCUMENTATION_GUIDE.md](./DOCUMENTATION_GUIDE.md) to find the right document
2. Search the relevant document with Ctrl+F
3. Check [IMPLEMENTATION_GUIDE.md troubleshooting](./IMPLEMENTATION_GUIDE.md#-troubleshooting)
4. Review [SECURITY_AUDIT.md](./SECURITY_AUDIT.md) if security-related

---

## 📅 Version Info

- **Version:** 1.0.0
- **Status:** Production-Ready
- **Last Updated:** March 27, 2026
- **Java:** 21
- **Next.js:** 16.1.6
- **PostgreSQL:** 14+

---

## 📖 Next Steps

1. **Try it locally:** [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md)
2. **Understand architecture:** [ARCHITECTURE.md](./ARCHITECTURE.md)
3. **Learn the API:** [DOCUMENTATION.md](./DOCUMENTATION.md)
4. **Prepare for production:** [SECURITY_AUDIT.md](./SECURITY_AUDIT.md)

---

**By STTL for enterprise form management.**
