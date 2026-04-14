# 🗄️ Database SQL Scripts

PostgreSQL database setup and seed data for FormBuilder

---

## 📋 Quick Decision Guide

### ✅ **Recommended: Use `schema-initializer.sql`**
**One file, everything setup automatically**

```bash
psql -U postgres formbuilder2 < schema-initializer.sql
```

**What it does (in ONE file):**
- ✅ Creates all 17 tables
- ✅ Creates all indexes
- ✅ Seeds 9 permissions
- ✅ Seeds 4 roles (ADMIN, ROLE_ADMIN, BUILDER, USER)
- ✅ Maps all role-permissions
- ✅ Seeds 3 modules (Forms, Workflows, Admin)
- ✅ Maps all role-modules
- ✅ Creates admin user (admin / admin@123456)
- ✅ Creates 2 sample test users (builder1, user1)
- ✅ Seeds system configurations
- ✅ All permissions already assigned!

**Time:** 2 minutes  
**Best for:** Fresh setup, different servers, starting over

---

### 📋 **Alternative: Use schema.sql then seeder.sql**
**Two files for more control**

```bash
# Step 1: Create tables
psql -U postgres formbuilder2 < schema.sql

# Step 2: Add data
psql -U postgres formbuilder2 < seeder.sql
```

**Best for:** Understanding the structure, selective updates

---

## 📋 Contents

### 1. **schema-initializer.sql** ⭐⭐⭐ RECOMMENDED
**Complete one-file database initialization**

Creates:
- All 17 core tables
- All indexes
- All permissions (9 types)
- All roles (ADMIN, ROLE_ADMIN, BUILDER, USER)
- Complete role-permission mapping
- All modules (Forms, Workflows, Administration)
- Complete role-module mapping
- Admin user with full permissions
- Sample test users
- System configurations
- Audit log entry

**Usage:**
```bash
psql -U postgres -c "CREATE DATABASE formbuilder2;"
psql -U postgres formbuilder2 < schema-initializer.sql
# Done! Database is 100% ready
```

**Size:** ~12 KB  
**Time to run:** <5 seconds  
**Perfect for:** Production setup, new environments, disaster recovery

---

### 2. **schema.sql** 
**Create empty table structure only**

Creates:
- All 17 tables (empty)
- All indexes
- No data inserted

**Usage:**
```bash
psql -U postgres formbuilder2 < schema.sql
# Then run seeder.sql to add data
```

**Size:** ~6.4 KB  
**Pairs with:** seeder.sql

---

### 3. **seeder.sql** 
**Add essential data to tables**

Adds:
- 9 permissions (READ, WRITE, EDIT, MANAGE, AUDIT, DELETE, EXPORT, APPROVE, VISIBILITY)
- 4 roles with descriptions
- Complete role-permission mappings
- 3 modules with descriptions
- Complete role-module mappings
- Admin user (admin / admin@123456)

**Usage:**
```bash
psql -U postgres formbuilder2 < seeder.sql
```

**Size:** ~4.5 KB  
**Requires:** schema.sql must be run first

**Default Credentials:**
```
Username: admin
Password: admin@123456
```

---

### 4. **mock_users_seeder.sql** 
**Optional: Additional test users**

Adds:
- builder1 (builder role)
- user1 (standard user role)

Use when you want more test users for testing different roles.

**Usage:**
```bash
psql -U postgres formbuilder2 < mock_users_seeder.sql
```

**Size:** ~2.2 KB  
**Requires:** seeder.sql must be run first

---

### 5. **unseed.sql** 
**Optional: Remove all data but keep schema**

Clears:
- All users
- All forms
- All submissions
- All audit logs
- But KEEPS table structure and role definitions

Use before re-seeding with fresh data.

**Usage:**
```bash
psql -U postgres formbuilder2 < unseed.sql
# Then run seeder.sql again for fresh data
```

**Size:** ~1.7 KB  
**⚠️ Warning:** Removes ALL data. Back up first if needed.

---

## 🚀 Quick Setup Guide

### **Option 1: Complete Setup (Recommended)**

```bash
# 1. Create database
psql -U postgres -c "CREATE DATABASE formbuilder2;"

# 2. Initialize everything at once
psql -U postgres formbuilder2 < schema-initializer.sql

# 3. Done! You now have:
#    ✅ Database with all tables
#    ✅ Roles and permissions
#    ✅ Admin user: admin / admin@123456
#    ✅ Test users: builder1, user1
#    ✅ Everything configured

# 4. Start your application
# Frontend: npm run dev
# Backend: ./mvnw spring-boot:run
```

**Total time:** ~5 minutes

---

### **Option 2: Step-by-Step Setup**

```bash
# 1. Create database
psql -U postgres -c "CREATE DATABASE formbuilder2;"

# 2. Create empty tables
psql -U postgres formbuilder2 < schema.sql

# 3. Add permissions, roles, admin user
psql -U postgres formbuilder2 < seeder.sql

# 4. Optionally add more test users
psql -U postgres formbuilder2 < mock_users_seeder.sql

# Done!
```

**Total time:** ~5 minutes

---

## 🔄 Reset Workflow

If you need to start fresh:

```bash
# 1. Clear all data (keep structure)
psql -U postgres formbuilder2 < unseed.sql

# 2. Re-seed fresh data
psql -U postgres formbuilder2 < seeder.sql

# 3. Done! Back to fresh state with empty forms
```

---

## 📊 Database Structure Overview

```
USERS (authentication)
├─ 1 admin user (all permissions)
├─ 2 test users (builder, user roles)
└─ Each user assigned to role(s)

ROLES (4 types)
├─ ADMIN - Full system access
├─ ROLE_ADMIN - Alias to ADMIN
├─ BUILDER - Can create/publish forms
└─ USER - Can submit forms

PERMISSIONS (9 types)
├─ MANAGE - Full admin
├─ READ - Read access
├─ WRITE - Create new
├─ EDIT - Modify existing
├─ AUDIT - View logs
├─ DELETE - Remove items
├─ EXPORT - Download data
├─ APPROVE - Workflow approval
└─ VISIBILITY - Control visibility

MODULES (3)
├─ Forms Management
├─ Workflows
└─ Administration

FORMS & DATA
├─ forms (metadata)
├─ form_versions (snapshots)
├─ form_fields (field definitions)
├─ form_submission_meta (submissions)
└─ [Dynamic tables: sub_form_X_vY] (created on publish)
```

---

## 🔐 Security & Passwords

### ⚠️ DEFAULT CREDENTIALS

**Admin User:**
```
Username: admin
Password: admin@123456
```

**Test Users** (from mock_users_seeder.sql):
```
builder1: builder@123456
user1:    user@123456
```

### ⚠️ IMPORTANT: Password Security

1. **These are DEFAULT passwords for setup only**
2. **Change immediately in production:**
   ```bash
   # In application, use admin panel to change password
   ```

3. **Password hashes are BCrypt** (salt cost 10)

4. **To generate new password hash:**
   - Use backend auth service
   - Or: https://bcrypt-generator.com/
   - Then update database: `UPDATE users SET password_hash='...' WHERE username='admin';`

---

## ✅ Default Data Reference

### Permissions (9 total)
| Name | Category | Description |
|------|----------|-------------|
| MANAGE | System | Full administrative access |
| READ | System | Read access to resources |
| WRITE | System | Write/Create new resources |
| EDIT | System | Edit existing resources |
| AUDIT | System | Access audit logs |
| DELETE | System | Delete resources |
| EXPORT | System | Export data |
| APPROVE | System | Approval authority |
| VISIBILITY | System | Visibility control |

### Roles (4 total)
| Name | Description | Permissions |
|------|-------------|-------------|
| ADMIN | Full access | All 9 permissions |
| ROLE_ADMIN | Alias to ADMIN | All 9 permissions |
| BUILDER | Form builder | READ, WRITE, EDIT, EXPORT, APPROVE |
| USER | Standard user | READ, APPROVE |

### Modules (3 total)
| Name | Prefix | Description |
|------|--------|-------------|
| Forms Management | /forms | Create, edit, publish forms |
| Workflows | /workflows | Manage form approvals |
| Administration | /admin | System admin panel |

### Users (3 total - from schema-initializer.sql)
| Username | Role | Status | Email |
|----------|------|--------|-------|
| admin | ADMIN | Active | admin@formbuilder.local |
| builder1 | BUILDER | Active | builder1@formbuilder.local |
| user1 | USER | Active | user1@formbuilder.local |

---

## 🛠️ Development Tips

### Connect with psql
```bash
psql -U postgres formbuilder2
```

### Useful SQL Queries

```sql
-- List all tables
\dt

-- Describe a specific table
\d users

-- Show all users
SELECT username, email, is_active FROM users;

-- Show all roles
SELECT name, description FROM roles;

-- Show user permissions
SELECT u.username, r.name as role, p.name as permission
FROM users u
JOIN user_form_roles ufr ON u.id = ufr.user_id
JOIN roles r ON ufr.role_id = r.id
JOIN role_permissions rp ON r.id = rp.role_id
JOIN permissions p ON rp.permission_id = p.id;

-- Count forms by status
SELECT status, COUNT(*) FROM forms GROUP BY status;

-- Show audit log
SELECT action, actor, created_at FROM audit_logs ORDER BY created_at DESC LIMIT 20;
```

---

## 📦 Backup & Restore

### Backup entire database
```bash
pg_dump -U postgres formbuilder2 > backup.sql
```

### Restore from backup
```bash
psql -U postgres -c "CREATE DATABASE formbuilder2;"
psql -U postgres formbuilder2 < backup.sql
```

### Backup specific table
```bash
pg_dump -U postgres -t forms formbuilder2 > forms_backup.sql
```

---

## ⚠️ Important Notes

1. **schema-initializer.sql is idempotent** - Can run multiple times safely
2. **All files use `IF NOT EXISTS`** - Won't error if tables exist
3. **Foreign keys are enforced** - Maintain referential integrity
4. **Soft deletes enabled** - Records marked as deleted, not removed
5. **UUIDs for all IDs** - Better for distributed systems
6. **Timestamps are timezone-aware** - Always use WITH TIME ZONE

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Permission denied | Ensure PostgreSQL user has privileges |
| Table already exists | Safe - files use `IF NOT EXISTS` |
| Foreign key error | Ensure schema.sql ran first |
| Password auth failed | Check PostgreSQL user password |
| Database doesn't exist | Run `CREATE DATABASE formbuilder2;` first |
| Duplicate key error | Data already seeded - safe to repeat |

---

## 📋 File Usage Matrix

| Use Case | File(s) | Steps |
|----------|---------|-------|
| **Fresh install** | schema-initializer.sql | 1 |
| **Fresh install (step-by-step)** | schema.sql + seeder.sql | 2 |
| **Add more test users** | + mock_users_seeder.sql | +1 |
| **Clear & start over** | unseed.sql + seeder.sql | 2 |
| **Just schema, no data** | schema.sql | 1 |

---

## 🔄 Execution Order

**Always follow this order:**

```
1. schema.sql (or schema-initializer.sql)
   └─ Creates tables

2. seeder.sql (if not using schema-initializer.sql)
   └─ Adds permissions, roles, users

3. mock_users_seeder.sql (OPTIONAL)
   └─ Adds extra test users
```

---

## 📖 More Information

- **Backend setup:** See [formbuilder-backend1/README.md](../formbuilder-backend1/README.md)
- **Frontend setup:** See [formbuilder-frontend1/README.md](../formbuilder-frontend1/README.md)
- **Full documentation:** See [../README.md](../README.md)

---

**Last Updated:** April 2026  
**Version:** 2.0 (Updated with schema-initializer.sql)  
**Status:** Production-Ready

