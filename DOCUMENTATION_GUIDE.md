# 📚 Documentation Guide

**Last Updated:** April 2026  
**Status:** Complete - All features enabled & tested

Quick navigation for finding the right documentation based on your needs.

---

## 📑 Document Overview

| Document | Purpose | Read Time | For Whom |
|----------|---------|-----------|----------|
| **[README.md](./README.md)** | Project overview & quick start | 5 min | Everyone - start here |
| **[Frontend README](./formbuilder-frontend1/README.md)** | Frontend features, components, architecture | 10 min | Frontend developers |
| **[Backend README](./formbuilder-backend1/README.md)** | Backend features, APIs, services | 10 min | Backend developers |
| **[SQL README](./sql/README.md)** | Database setup & seed data | 5 min | DevOps, DB admins |
| **[ARCHITECTURE.md](./ARCHITECTURE.md)** | System design, data flows, tech stack | 20 min | Architects, developers |
| **[SECURITY_AUDIT.md](./SECURITY_AUDIT.md)** | Security assessment & hardening | 15 min | Security team, DevOps |
| **[TESTING_GUIDE.md](./TESTING_GUIDE.md)** | Testing strategy & coverage | 10 min | QA, testers |

---

## 🎯 What Do You Want to Do?

### 🚀 **Get the System Running**
**Read:** 
1. [README.md](./README.md#-quick-start) - Quick start basics
2. [SQL README](./sql/README.md) - Database setup with detailed steps
3. [Frontend README](./formbuilder-frontend1/README.md#-quick-start) - Frontend quick start
4. [Backend README](./formbuilder-backend1/README.md#-quick-start) - Backend quick start

**Covers:**
- Prerequisites (Node, Java, PostgreSQL 14+)
- Database setup from SQL scripts
- Starting backend server (:8080)
- Starting frontend server (:3000)
- Testing with demo forms
- **Time:** 10-15 minutes

---

### 🏗️ **Understand the Architecture**
**Read:** 
1. [ARCHITECTURE.md](./ARCHITECTURE.md) - System overview & flows
2. [Backend README](./formbuilder-backend1/README.md) - Backend structure & services
3. [Frontend README](./formbuilder-frontend1/README.md) - Frontend structure & components

**Covers:**
- System overview & components
- How forms flow: creation → publication → submission
- Database structure (metadata + dynamic tables)
- Workflow & Rule engines (in detail)
- Technology stack & why each choice
- Backend API organization
- Frontend component architecture
- Data flow diagrams
- **Time:** 25-30 minutes
- **For:** Developers, system architects, DevOps

---

### 📋 **Learn Form Building Features**
**Read:** [FORM_BUILDER_SPECIFICATION.md](./FORM_BUILDER_SPECIFICATION.md)
- Complete feature list
- Form types & field types supported
- Validation rules
- Workflow/approval system
- Rule engine capabilities
- Public vs authenticated forms
- **Time:** 15 minutes
- **For:** Product managers, form builders, testers

---

### 🔒 **Prepare for Production / Security**
**Read:** [SECURITY_AUDIT.md](./SECURITY_AUDIT.md)
- Current security status
- Identified risks (and how we fixed them)
- Production hardening checklist
- HTTPS configuration
- Database security settings
- Incident response procedures
- **Time:** 15 minutes
- **For:** Security team, DevOps, system admins

---

### 💻 **Integrate via API**
**Read:** 
1. [Backend README - API Endpoints](./formbuilder-backend1/README.md#-api-endpoints) - All API routes
2. [ARCHITECTURE.md - API Routes](./ARCHITECTURE.md#-api-routes) - API structure

**Status:** API endpoints are centralized:
- **Backend:** `src/main/java/com/sttl/formbuilder2/util/ApiConstants.java`
- **Frontend:** `src/utils/apiConstants.ts`
- All 15 controllers use centralized constants
- Change `VERSION = "v1"` to `"v2"` updates all endpoints

**Example Endpoints:**
```
POST   /api/v1/auth/login
GET    /api/v1/auth/me
POST   /api/v1/forms
GET    /api/v1/forms/{formId}
POST   /api/v1/workflows/initiate
GET    /api/v1/workflows/available-authorities
```

**For details:** Review the controllers in `formbuilder-backend1/src/main/java/com/sttl/formbuilder2/controller/`

---

### 🧪 **Test the System**
**Basic Flow:**
1. Start backend: `./gradlew bootRun`
2. Start frontend: `npm run dev`
3. Navigate to `http://localhost:3000`
4. Login (default: admin/admin)
5. Create a form → Publish → Share link
6. Fill form via public link

**For workflow testing:**
1. Create a form
2. Publish it
3. Click "Initiate Workflow" button
4. Select an approver
5. Submit for approval
6. Log in as approver → Approve/Reject

---

### 🔧 **Fix Issues / Debug**
**Common Issues:**

| Problem | Solution |
|---------|----------|
| Auth returning only username | ✅ Fixed - now returns userId + roles array |
| Black borders everywhere | ✅ Fixed - CSS syntax corrected |
| Workflow modal not visible | ✅ Fixed - styled properly |
| Rule engine not showing | ✅ Fixed - uncommented tab |
| UUID type mismatch (409 error) | ✅ Fixed - validateFormCode excludes current form |

**For new issues:**
- Check backend logs: `target/app.log`
- Check frontend console: F12 → Console tab
- Search error code in SECURITY_AUDIT.md

---

## 📚 Document Structure

```
FormBuilder3/
├─ README.md                          ← START HERE (project overview)
├─ ARCHITECTURE.md                    ← How it works (design & flows)
├─ SECURITY_AUDIT.md                  ← Production safety & hardening
├─ TESTING_GUIDE.md                   ← Testing strategy
├─ DOCUMENTATION_GUIDE.md             ← You are here
│
├─ sql/                               ← Database Scripts (NEW!)
│  ├─ README.md                       ← SQL usage & setup guide
│  ├─ schema.sql                      ← Create all tables (RUN FIRST)
│  ├─ seeder.sql                      ← Populate test data (RUN SECOND)
│  ├─ mock_users_seeder.sql           ← Additional test users (optional)
│  └─ unseed.sql                      ← Clear data (cleanup)
│
├─ formbuilder-frontend1/
│  ├─ README.md                       ← Frontend features & structure
│  ├─ src/
│  ├─ package.json
│  └─ ...
│
└─ formbuilder-backend1/
   ├─ README.md                       ← Backend features & APIs
   ├─ src/
   ├─ pom.xml
   └─ ...
```

---

## 🚀 Feature Checklist

✅ **Basic Form Building**
- ✅ Create forms with drag-and-drop
- ✅ Add text, numeric, date, select fields
- ✅ Configure field validation
- ✅ Set theme colors & fonts
- ✅ Publish forms to PostgreSQL

✅ **Rule Engine**
- ✅ Visual rule builder (IF-THEN logic)
- ✅ Conditional show/hide fields
- ✅ Enable/disable fields based on values
- ✅ Cross-field validation
- ✅ Server-side rule evaluation

✅ **Workflow & Approval**
- ✅ Initiate workflows from builder
- ✅ Select approvers
- ✅ Multi-step approval chains
- ✅ Approve/reject with comments
- ✅ Audit trail for all decisions

✅ **Form Versioning**
- ✅ Create new form versions
- ✅ Activate/deactivate versions
- ✅ Submissions tied to exact version
- ✅ Schema changes don't break old submissions

✅ **User Management**
- ✅ User registration
- ✅ Role-based access control
- ✅ Session-based authentication
- ✅ Permission management

✅ **Data Management**
- ✅ View form responses
- ✅ Export to CSV
- ✅ Bulk delete/restore
- ✅ Soft deletes (recovery possible)
- ✅ Audit logs

✅ **API**
- ✅ 15 controllers (all using ApiConstants)
- ✅ Centralized path management
- ✅ Version constants for easy upgrades
- ✅ Consistent error handling
- ✅ Proper HTTP status codes

---

## 🛠️ Recent Updates (April 2026)

### Code Organization
- ✅ Created `ApiConstants.java` for backend paths
- ✅ Created `apiConstants.ts` for frontend paths
- ✅ Migrated all 13 backend controllers
- ✅ Single source of truth for API versioning

### Bug Fixes
- ✅ Auth login response now includes userId and roles
- ✅ Fixed CSS syntax errors (Tailwind)
- ✅ Fixed form code uniqueness validation
- ✅ Fixed UUID type handling

### Features Enabled
- ✅ Workflow engine fully operational
- ✅ Rule engine UI and logic complete
- ✅ All commented code uncommented
- ✅ All styling fixed

---

## 📞 Support

### Where to Find...

| Need | Look In |
|------|----------|
| **Quick setup** | [README.md](./README.md#-quick-start) |
| **Database setup** | [sql/README.md](./sql/README.md) |
| **Frontend features** | [formbuilder-frontend1/README.md](./formbuilder-frontend1/README.md) |
| **Backend features** | [formbuilder-backend1/README.md](./formbuilder-backend1/README.md) |
| **How features work** | [ARCHITECTURE.md](./ARCHITECTURE.md) |
| **What's supported** | [FORM_BUILDER_SPECIFICATION.md](./FORM_BUILDER_SPECIFICATION.md) |
| **Security info** | [SECURITY_AUDIT.md](./SECURITY_AUDIT.md) |
| **API endpoints** | [Backend README - API Endpoints](./formbuilder-backend1/README.md#-api-endpoints) |
| **Frontend API calls** | [src/services/api.ts](./formbuilder-frontend1/src/services/api.ts) |
| **Backend config** | [application.properties](./formbuilder-backend1/src/main/resources/application.properties) |
| **Testing** | [TESTING_GUIDE.md](./TESTING_GUIDE.md) |

---

## ✨ Next Steps

1. **Read [README.md](./README.md)** to get started quickly
2. **Run [sql/README.md setup](./sql/README.md)** to initialize your database
3. **Review [ARCHITECTURE.md](./ARCHITECTURE.md)** to understand the system
4. **Check [SECURITY_AUDIT.md](./SECURITY_AUDIT.md)** before any production deployment
5. **Explore [Frontend README](./formbuilder-frontend1/README.md)** and **[Backend README](./formbuilder-backend1/README.md)** based on your role
6. **Run tests** and verify the workflow approval chain works

---

## 📖 Reading Path by Role

### For **New Developers**
1. Start: **[README.md](./README.md)** (overview)
2. Then: **[sql/README.md](./sql/README.md)** (database)
3. Then: **[ARCHITECTURE.md](./ARCHITECTURE.md)** (understanding design)
4. Next: **[Backend README](./formbuilder-backend1/README.md)** (backend structure)
5. Then: **[Frontend README](./formbuilder-frontend1/README.md)** (frontend structure)
6. Finally: **[SECURITY_AUDIT.md](./SECURITY_AUDIT.md)** (security concerns)

### For **Frontend Developers**
1. Start: **[Frontend README](./formbuilder-frontend1/README.md)** (your codebase)
2. Then: **[ARCHITECTURE.md](./ARCHITECTURE.md)** (system context)
3. Reference: **[Backend README](./formbuilder-backend1/README.md)** (API structure)
4. As needed: **[SECURITY_AUDIT.md](./SECURITY_AUDIT.md)** (security features)

### For **Backend Developers**
1. Start: **[Backend README](./formbuilder-backend1/README.md)** (your codebase)
2. Then: **[sql/README.md](./sql/README.md)** (database structure)
3. Then: **[ARCHITECTURE.md](./ARCHITECTURE.md)** (system context)
4. Reference: **[Frontend README](./formbuilder-frontend1/README.md)** (integration points)
5. Finally: **[SECURITY_AUDIT.md](./SECURITY_AUDIT.md)** (security hardening)

### For **DevOps Engineers**
1. Start: **[README.md](./README.md)** (quick overview)
2. Then: **[sql/README.md](./sql/README.md)** (database deployment)
3. Then: **[SECURITY_AUDIT.md](./SECURITY_AUDIT.md)** (hardening checklist)
4. Reference: **[ARCHITECTURE.md](./ARCHITECTURE.md)** (system design questions)

### For **API Consumers**
1. Start: **[Backend README - API Endpoints](./formbuilder-backend1/README.md#-api-endpoints)** (routes)
2. Reference: **[ARCHITECTURE.md](./ARCHITECTURE.md)** (system context)
3. As needed: **[README.md](./README.md)** (general info)

### For **Security Team**
1. Start: **[SECURITY_AUDIT.md](./SECURITY_AUDIT.md)** (current status)
2. Then: **[ARCHITECTURE.md](./ARCHITECTURE.md)** (security features section)
3. Reference: **[Backend README](./formbuilder-backend1/README.md)** (API security)

---

## 🎓 Quick Answers

### "How do I set up the project?"
→ [README.md Quick Start](./README.md#-quick-start) + [sql/README.md](./sql/README.md)

### "What are the main features?"
→ [README.md Features Section](./README.md#-main-highlighting-features)

### "How do I create a form and collect responses?"
→ [ARCHITECTURE.md - Form Publication & Submission](./ARCHITECTURE.md#-how-it-works-form-publication)

### "What are all the API endpoints?"
→ [Backend README - API Endpoints](./formbuilder-backend1/README.md#-api-endpoints)

### "Is this secure?"
→ [SECURITY_AUDIT.md](./SECURITY_AUDIT.md#-security-features-already-implemented)

### "How do I deploy to production?"
→ [SECURITY_AUDIT.md - Hardening Checklist](./SECURITY_AUDIT.md#-security-hardening-checklist)

### "What's the frontend structure?"
→ [Frontend README - Project Structure](./formbuilder-frontend1/README.md#-frontend-project-structure)

### "What's the backend structure?"
→ [Backend README - Project Structure](./formbuilder-backend1/README.md#-backend-project-structure)

### "How does the rule engine work?"
→ [ARCHITECTURE.md - Rule Engine](./ARCHITECTURE.md#-rule-engine)

### "How does the workflow system work?"
→ [Backend README - Workflow & Approval System](./formbuilder-backend1/README.md#-workflow--approval-system)

### "How does the database work?"
→ [sql/README.md](./sql/README.md) + [ARCHITECTURE.md - Database Structure](./ARCHITECTURE.md#-database-structure)

---

## 📊 Project Statistics (April 2026)

- **100+** Backend classes and services
- **20+** Frontend React components
- **15** API controllers
- **50+** API endpoints
- **16** Database core entities
- **30+** Field types supported
- **4** SQL setup scripts (organized in sql/ folder)
- **7** Root-level documentation files
- **3** Folder-specific READMEs (frontend, backend, sql)

---

## 💡 Pro Tips

- **Ctrl+F (Cmd+F)** to search within documents
- **Bookmark** the API documentation for easy reference
- **Combine documents**: Read ARCHITECTURE while setting up (IMPLEMENTATION_GUIDE) to understand what's happening
- **Check troubleshooting** section before asking for help
- **Run through production checklist** before deploying

---

**Last Updated:** March 27, 2026
**Version:** 1.0-Final
