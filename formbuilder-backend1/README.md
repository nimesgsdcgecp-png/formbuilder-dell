# 🔧 FormBuilder Backend

**Enterprise-Grade API Server for Form Management**  
Built with Spring Boot, Java 21, PostgreSQL, and REST principles

---

## ⚡ Quick Start

```bash
# Prerequisites
# - Java 21
# - Maven 3.9+
# - PostgreSQL 14+

# 1. Create database
psql -U postgres -c "CREATE DATABASE formbuilder2;"

# 2. Run database setup
psql -U postgres formbuilder2 < ../sql/schema.sql
psql -U postgres formbuilder2 < ../sql/seeder.sql

# 3. Start backend
./mvnw spring-boot:run

# Runs on: http://localhost:8080
# API Docs: http://localhost:8080/swagger-ui.html
```

---

## ✨ Backend Features

### 🔐 **Authentication & Authorization**
- **Session-based authentication** (JSESSIONID cookies)
- **Role-based access control (RBAC)** - ADMIN, MENTOR, INTERN roles
- **Password hashing** with BCrypt
- **User registration & login** endpoints
- **Permission management** per role per module
- **Session timeout** - 15 min idle timeout
- **Account lockout** - Configurable after failed attempts

### 📋 **Form Management**
- **Create forms** - Draft management
- **Update forms** - Schema changes while in draft
- **Publish forms** - Create PostgreSQL tables automatically
- **List forms** - With pagination & filtering
- **Get form details** - Full schema with fields and rules
- **Form versioning** - Each publish creates immutable snapshot
- **Form deletion** - Soft delete with recovery
- **Archive forms** - Move old forms out of active list

### 🗂️ **Dynamic Form Data Storage**
- **Automatic table creation** - Tables named `sub_form_X_vY`
- **Column generation** from field definitions
- **Data type mapping** - TEXT, NUMERIC, DATE, BOOLEAN, TEXTAREA
- **Validation enforcement** at database level
- **Parameterized queries** - SQL injection prevention
- **Transaction management** - ACID compliance

### 📝 **Form Field Management**
- **30+ field types** support
- **Field configuration** - labels, placeholders, defaults
- **Validation rules** - min/max, regex, custom rules
- **Required fields** - Enforce mandatory inputs
- **Field ordering** - Control display order
- **Field types:** TEXT, NUMERIC, DATE, BOOLEAN, TEXTAREA, SELECT, CHECKBOX, RADIO, EMAIL, PHONE, URL, etc.

### 🧠 **Rule Engine**
- **Conditional logic evaluation** - IF-THEN rules
- **Client-side evaluation** - Instant feedback
- **Server-side evaluation** - Data integrity
- **Operators supported:**
  - `equals`, `notEquals`, `greaterThan`, `lessThan`
  - `contains`, `startsWith`, `endsWith`
- **Actions supported:**
  - `show`, `hide`, `enable`, `disable`, `require`, `clearValue`
- **Rule validation** - Syntax checking before save
- **Rule caching** - Performance optimization

### 🔄 **Workflow & Approval System**
- **Workflow initiation** from forms
- **Approver assignment** - Select workflow authorities
- **Multi-step approvals** - Chain multiple approvers
- **Approval tracking** - Track approval status
- **Approval feedback** - Comments from approvers
- **Reject capability** - Bounce back submissions
- **Approval history** - Complete audit trail
- **Authority management** - Define approval roles

### 📤 **Form Submission & Response Management**
- **Submit responses** - Insert into dynamic tables
- **Server-side validation** - Validate all data
- **Server-side rule evaluation** - Prevent tampering
- **Response drafts** - Save-in-progress functionality
- **List responses** - Get all submissions for a form
- **Get response detail** - View individual submission
- **Delete responses** - Soft delete with recovery
- **CSV export** - Generate response reports
- **Response filtering** - Search and sort

### 📊 **Public Form Sharing**
- **Generate share tokens** - UUID-based public links
- **Public form access** - No authentication required
- **Share token management** - Regenerate or disable
- **Public link structure** - `/f/{shareToken}`
- **Anonymous submissions** - Support public form filling
- **Rate limiting** - Optional throttling per token

### 👥 **User Management** (Admin only)
- **Create users** - Register new accounts
- **List users** - With pagination
- **Get user details** - Full user info
- **Update users** - Edit user data
- **Delete users** - Soft delete with recovery
- **Activate/deactivate** - Enable/disable accounts
- **Assign roles** - ADMIN, MENTOR, INTERN
- **Module permissions** - Granular access control

### 🎯 **Role & Module Management** (Admin only)
- **Predefined roles** - ADMIN, MENTOR, INTERN
- **Module list** - Available modules/features
- **Role-module mapping** - Assign features per role
- **Permission validation** - Check access before action
- **Default permissions** - Pre-configured for common use

### 📊 **Audit & Logging**
- **Audit logs** - Track all user actions
- **Form changes** - Log create/update/delete
- **Submission logs** - Log all submissions
- **User actions** - Track login/logout/role changes
- **Admin actions** - Log user management changes
- **Timestamp** - All events timestamped
- **Audit trail** - Complete history for compliance

### 🔍 **Search & Filtering**
- **Form search** - By title, description, code
- **Response search** - Filter by field values
- **User search** - Find users by name/email
- **Pagination** - Handle large datasets
- **Sorting** - Ascending/descending
- **Date range** - Filter by date ranges

### 🛡️ **Security Features**
- ✅ **SQL injection prevention** - Parameterized queries
- ✅ **CSRF protection** - SameSite cookies
- ✅ **Session hijacking prevention** - HTTPOnly cookies
- ✅ **Password hashing** - BCrypt with salt
- ✅ **Input validation** - Server-side validation
- ✅ **Authorization checks** - Role-based access
- ✅ **Error handling** - No sensitive info in errors
- ✅ **HTTPS ready** - Secure cookie flags

---

## 📁 Backend Project Structure

```
formbuilder-backend1/
├── pom.xml                                # Maven configuration
├── mvnw                                   # Maven wrapper
│
├── src/main/java/com/sttl/formbuilder2/
│   ├── FormbuilderApplication.java       # SpringBoot entry point
│   │
│   ├── config/
│   │   ├── SecurityConfig.java           # Spring Security configuration
│   │   ├── WebConfig.java                # CORS, interceptors
│   │   └── ...other configs
│   │
│   ├── controller/
│   │   ├── AuthController.java           # Login, logout, registration
│   │   ├── FormController.java           # CRUD forms
│   │   ├── FormFieldController.java      # Form fields management
│   │   ├── RuleController.java           # Rule engine endpoints
│   │   ├── RuntimeController.java        # Submit responses
│   │   ├── WorkflowController.java       # Approval workflows
│   │   ├── UserController.java           # User management (admin)
│   │   ├── RoleController.java           # Role management (admin)
│   │   ├── ResponseController.java       # View responses
│   │   ├── AuditController.java          # Audit logs
│   │   └── ...other controllers
│   │
│   ├── service/
│   │   ├── AuthService.java              # Authentication logic
│   │   ├── FormService.java              # Form CRUD
│   │   ├── FormVersionService.java       # Version management
│   │   ├── RuleEngineService.java        # Rule evaluation
│   │   ├── SubmissionService.java        # Response handling
│   │   ├── WorkflowService.java          # Workflow logic
│   │   ├── UserService.java              # User management
│   │   ├── RoleService.java              # Role management
│   │   ├── DynamicTableService.java      # Create tables dynamically
│   │   ├── ValidationService.java        # Field validation
│   │   ├── AuditService.java             # Logging
│   │   └── ...other services
│   │
│   ├── repository/
│   │   ├── FormRepository.java           # JPA form queries
│   │   ├── FormFieldRepository.java      # JPA field queries
│   │   ├── FormVersionRepository.java    # JPA version queries
│   │   ├── RuleRepository.java           # JPA rule queries
│   │   ├── UserRepository.java           # JPA user queries
│   │   ├── RoleRepository.java           # JPA role queries
│   │   ├── AuditLogRepository.java       # JPA audit queries
│   │   └── ...other repositories
│   │
│   ├── entity/
│   │   ├── Form.java                     # Form metadata
│   │   ├── FormVersion.java              # Versioned snapshot
│   │   ├── FormField.java                # Field definitions
│   │   ├── Rule.java                     # Rule definitions
│   │   ├── User.java                     # User entity
│   │   ├── Role.java                     # Role entity
│   │   ├── Module.java                   # Module/feature
│   │   ├── AuditLog.java                 # Audit trail
│   │   ├── Workflow.java                 # Workflow entity
│   │   └── ...other entities
│   │
│   ├── dto/
│   │   ├── FormDTO.java                  # Data transfer object
│   │   ├── CreateFormRequest.java        # API request
│   │   ├── UpdateFormRequest.java        # API request
│   │   ├── FormFieldDTO.java             # Field DTO
│   │   ├── RuleDTO.java                  # Rule DTO
│   │   ├── SubmitResponseRequest.java    # Submission request
│   │   ├── UserDTO.java                  # User DTO
│   │   ├── ApiResponse.java              # Standard response
│   │   └── ...other DTOs
│   │
│   ├── exception/
│   │   ├── GlobalExceptionHandler.java   # Central error handling
│   │   ├── FormNotFoundException.java    # Custom exceptions
│   │   ├── ValidationException.java
│   │   └── ...other exceptions
│   │
│   ├── security/
│   │   ├── JwtTokenProvider.java        # JWT generation (if used)
│   │   ├── SecurityUtils.java            # Auth utilities
│   │   └── CustomUserDetails.java        # UserDetails impl
│   │
│   ├── util/
│   │   ├── ApiConstants.java             # API paths (centralized)
│   │   ├── ValidationUtils.java          # Validation helpers
│   │   ├── FieldTypeConverter.java       # Type mapping
│   │   └── ...other utilities
│   │
│   └── aspect/
│       ├── LoggingAspect.java            # AOP logging
│       └── ...other aspects
│
├── src/main/resources/
│   ├── application.properties             # Main configuration
│   ├── application-dev.properties         # Dev profile
│   ├── application-prod.properties        # Prod profile
│   └── ...other configs
│
├── src/test/java/
│   ├── .../service/                      # Service tests
│   ├── .../controller/                   # Controller tests
│   └── ...test classes
│
├── target/                               # Compiled output
└── README.md                             # This file
```

---

## 🛠️ Technology Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| **Spring Boot** | 3.5.11 | Web framework |
| **Java** | 21 | Programming language |
| **Spring Data JPA** | Latest | ORM |
| **PostgreSQL** | 14+ | Database |
| **Spring Security** | Latest | Authentication & Authorization |
| **Maven** | 3.9+ | Build tool |
| **Lombok** | Latest | Reduce boilerplate |
| **Swagger/Springdoc** | Latest | API documentation |

---

## 🔌 API Endpoints

All endpoints are centralized in `ApiConstants.java`:

### Authentication
```
POST   /api/v1/auth/login              # User login
POST   /api/v1/auth/logout             # User logout
GET    /api/v1/auth/me                 # Current user info
POST   /api/v1/auth/register           # User registration
```

### Forms
```
GET    /api/v1/forms                   # List all forms
POST   /api/v1/forms                   # Create form
GET    /api/v1/forms/{id}              # Get form details
PUT    /api/v1/forms/{id}              # Update form
DELETE /api/v1/forms/{id}              # Delete form
POST   /api/v1/forms/{id}/publish      # Publish form
```

### Form Fields
```
POST   /api/v1/forms/{id}/fields       # Add field
PUT    /api/v1/forms/{id}/fields/{fid} # Update field
DELETE /api/v1/forms/{id}/fields/{fid} # Remove field
```

### Rules
```
POST   /api/v1/forms/{id}/rules        # Add rule
GET    /api/v1/forms/{id}/rules        # Get rules
PUT    /api/v1/forms/{id}/rules/{rid}  # Update rule
DELETE /api/v1/forms/{id}/rules/{rid}  # Delete rule
```

### Submissions/Runtime
```
POST   /api/v1/runtime/submit          # Submit response
GET    /api/v1/forms/{id}/responses    # List responses
GET    /api/v1/responses/{rid}         # Get response detail
DELETE /api/v1/responses/{rid}         # Delete response
GET    /api/v1/runtime/drafts/{id}     # Get draft submission
```

### Workflows
```
POST   /api/v1/workflows/initiate      # Start workflow
GET    /api/v1/workflows/{id}          # Get workflow status
POST   /api/v1/workflows/{id}/approve  # Approve
POST   /api/v1/workflows/{id}/reject   # Reject
GET    /api/v1/workflows/available-authorities # Get approvers
```

### Admin - Users
```
GET    /api/v1/admin/users             # List users
POST   /api/v1/admin/users             # Create user
GET    /api/v1/admin/users/{id}        # Get user
PUT    /api/v1/admin/users/{id}        # Update user
DELETE /api/v1/admin/users/{id}        # Delete user
```

### Admin - Roles
```
GET    /api/v1/admin/roles             # List roles
POST   /api/v1/admin/roles             # Create role
PUT    /api/v1/admin/roles/{id}        # Update role
```

### Admin - Audit
```
GET    /api/v1/admin/audit             # Get audit logs
GET    /api/v1/admin/audit/{id}        # Get audit detail
```

---

## 📊 Database Design

### Core Tables

**FORMS** - Form metadata
```sql
id (PK)                    -- Auto-increment
title (VARCHAR)            -- Form name
description (TEXT)         -- Form description
code (VARCHAR, UNIQUE)     -- Unique identifier
status (ENUM)              -- DRAFT, PUBLISHED, ARCHIVED
share_token (UUID, UNIQUE)-- Public share link
created_by_id (FK→USERS)   -- Who created
created_at (TIMESTAMP)     -- Creation time
updated_at (TIMESTAMP)     -- Last update
```

**FORM_VERSIONS** - Immutable snapshots
```sql
id (PK)
form_id (FK→FORMS)
version_number (INT)
rules (JSON)               -- Conditional logic
published_at (TIMESTAMP)
created_at (TIMESTAMP)
UNIQUE (form_id, version_number)
```

**FORM_FIELDS** - Field definitions
```sql
id (PK)
form_version_id (FK→FORM_VERSIONS)
column_name (VARCHAR)      -- DB column name
field_label (VARCHAR)      -- User-facing label
field_type (ENUM)          -- TEXT, NUMERIC, DATE, etc.
is_mandatory (BOOLEAN)
validation_rules (JSONB)   -- Validation config
ordinal_position (INT)     -- Display order
UNIQUE (form_version_id, column_name)
```

**USERS** - System users
```sql
id (PK)
username (VARCHAR, UNIQUE)
email (VARCHAR, UNIQUE)
password (VARCHAR)         -- BCrypt hashed
role_id (FK→ROLES)
is_active (BOOLEAN)
created_at (TIMESTAMP)
```

**ROLES** - Role definitions
```sql
id (PK)
role_name (VARCHAR, UNIQUE) -- ADMIN, MENTOR, INTERN
description (TEXT)
```

**AUDIT_LOGS** - Change tracking
```sql
id (PK)
user_id (FK→USERS)
action (VARCHAR)           -- CREATE, UPDATE, DELETE, etc.
entity_type (VARCHAR)      -- FORM, USER, etc.
entity_id (BIGINT)
old_value (JSONB)
new_value (JSONB)
created_at (TIMESTAMP)
```

### Dynamic Submission Tables

Created on form publish: `sub_form_{formId}_v{version}`
```sql
submission_id (PK)
field_1 (datatype)         -- One column per form field
field_2 (datatype)
...
submitted_at (TIMESTAMP)
created_by_id (FK→USERS)
```

---

## 🚀 Development Commands

```bash
# Clean and build
./mvnw clean install

# Start dev server (auto-reload with devtools)
./mvnw spring-boot:run

# Run tests
./mvnw test

# Generate API documentation
./mvnw springdoc-openapi:generate

# Package for production
./mvnw clean package
```

---

## 🔐 Security Configuration

Located in `application.properties`:

```properties
# CORS Settings
cors.allowed-origins=http://localhost:3000
cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS

# Session Management
server.servlet.session.timeout=15m
server.servlet.session.cookie.http-only=true
server.servlet.session.cookie.same-site=lax

# Database
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.properties.hibernate.jdbc.prep_stmt_cache_size=250

# Logging
logging.level.root=INFO
logging.level.com.sttl.formbuilder2=DEBUG
```

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Database not found | Run: `CREATE DATABASE formbuilder2;` |
| Port 8080 in use | Change in application.properties: `server.port=8081` |
| Connection refused | Ensure PostgreSQL is running |
| Password expired | Reset in PostgreSQL |
| Permission denied | Grant user permissions: `ALTER USER postgres WITH PASSWORD 'password';` |

---

## 📞 Need Help?

- Check parent project [README.md](../README.md)
- Review [ARCHITECTURE.md](../ARCHITECTURE.md) for system overview
- See [SECURITY_AUDIT.md](../SECURITY_AUDIT.md) for security questions
- View [swagger-ui.html](http://localhost:8080/swagger-ui.html) when running

---

**Last Updated:** April 2026  
**Status:** Production-Ready  
**Maintainer:** STTL
