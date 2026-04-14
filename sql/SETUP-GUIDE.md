# 🚀 Database Setup Guide

**Quick reference for setting up FormBuilder3 database from scratch**

---

## ⚡ 30-Second Quick Start

```bash
# 1. Create database
psql -U postgres -c "CREATE DATABASE formbuilder2;"

# 2. Initialize everything
psql -U postgres formbuilder2 < schema-initializer.sql

# 3. Done! You're ready
# Login: admin / admin@123456
```

---

## 📋 What You Get

When you run `schema-initializer.sql`, you get:

✅ **17 Database Tables**
- users, roles, permissions, modules
- forms, form_versions, form_fields
- workflows, workflow_steps
- audit_logs, and more...

✅ **Security Setup**
- 9 permissions (READ, WRITE, EDIT, MANAGE, AUDIT, DELETE, EXPORT, APPROVE, VISIBILITY)
- 4 roles (ADMIN, ROLE_ADMIN, BUILDER, USER)
- Complete role-permission mapping
- All role-module mapping

✅ **Users Ready**
- admin (admin@123456) - Full access
- builder1 (builder@123456) - Form builder
- user1 (user@123456) - Standard user

✅ **Ready to Go**
- All indexes created
- System configurations set
- Audit log initialized
- Database optimized

---

## 🎯 Three Ways to Setup

### Option 1️⃣ : One-File Setup (RECOMMENDED)
**Best for:** Production, different servers, quick setup

```bash
psql -U postgres formbuilder2 < schema-initializer.sql
```

✅ **Pros:** One command, everything done, idempotent  
⏱️ **Time:** <5 seconds  
📝 **Experience:** All-in-one

---

### Option 2️⃣ : Two-File Setup (Step-by-Step)
**Best for:** Learning, understanding structure, custom modifications

```bash
psql -U postgres formbuilder2 < schema.sql
psql -U postgres formbuilder2 < seeder.sql
```

✅ **Pros:** More control, see each step  
⏱️ **Time:** <10 seconds  
📝 **Experience:** Educational

---

### Option 3️⃣ : Full Control Setup (For Experts)
**Best for:** Advanced customization, migrations

```bash
psql -U postgres formbuilder2 < schema.sql
# Customize as needed
psql -U postgres formbuilder2 < seeder.sql          # Permissions & Roles
psql -U postgres formbuilder2 < mock_users_seeder.sql  # Extra test users
```

✅ **Pros:** Complete flexibility  
⏱️ **Time:** <15 seconds  
📝 **Experience:** Custom setup

---

## 📖 File Guide

| File | Purpose | Lines | Size | Requirement |
|------|---------|-------|------|-------------|
| **schema-initializer.sql** | Everything in one | 513 | 25KB | ⭐⭐⭐ RECOMMENDED |
| **schema.sql** | Tables only | 317 | 13KB | Creates structure |
| **seeder.sql** | Essential data | 62 | 4.5KB | Needs schema.sql |
| **mock_users_seeder.sql** | Extra test users | 27 | 2.2KB | Optional |
| **unseed.sql** | Clear all data | 57 | 1.7KB | Optional cleanup |

---

## 🔐 Login Credentials

| User | Password | Role | Purpose |
|------|----------|------|---------|
| **admin** | admin@123456 | ADMIN | Full system access |
| builder1 | builder@123456 | BUILDER | Form creation |
| user1 | user@123456 | USER | Form submission |

### ⚠️ SECURITY REMINDER
Change passwords immediately in production!

---

## ✅ Verification Checklist

After setup, verify everything:

```bash
# Connect to database
psql -U postgres formbuilder2

# Check tables exist
\dt

# Check users
SELECT username, is_active FROM users;

# Check roles
SELECT name FROM roles;

# Check permissions
SELECT name FROM permissions;

# Check modules
SELECT module_name FROM modules;

# All should show data!
```

---

## 🔄 Reset to Fresh State

Want to start over with fresh data?

```bash
# Clear data but keep schema
psql -U postgres formbuilder2 < unseed.sql

# Re-seed with fresh data
psql -U postgres formbuilder2 < seeder.sql

# Done! Fresh database
```

---

## 🆘 Troubleshooting

### "ERROR: database does not exist"
```bash
# Create the database first
psql -U postgres -c "CREATE DATABASE formbuilder2;"
```

### "ERROR: role 'postgres' does not exist"
```bash
# Use correct PostgreSQL user
psql -U YOUR_POSTGRES_USER
```

### "Already exists" errors (safe to ignore)
```bash
# Files use IF NOT EXISTS - harmless if run multiple times
# Safe to re-run anytime
```

### Connection refused
```bash
# Ensure PostgreSQL is running
# Windows: Check Services
# Linux: sudo systemctl start postgresql
# Mac: brew services start postgresql@14
```

---

## 📚 Learn More

- **Complete SQL reference:** See [README.md](./README.md)
- **Backend setup:** See [../formbuilder-backend1/README.md](../formbuilder-backend1/README.md)
- **Frontend setup:** See [../formbuilder-frontend1/README.md](../formbuilder-frontend1/README.md)
- **Full project guide:** See [../README.md](../README.md)

---

**Version:** 2.0  
**Last Updated:** April 2026  
**Status:** Production-Ready
