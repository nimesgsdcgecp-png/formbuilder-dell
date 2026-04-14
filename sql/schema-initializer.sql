-- ==============================================================================
-- FormBuilder3 - Complete Database Initializer
-- ==============================================================================
-- IMPORTANT: This file creates the entire database from scratch with:
--   ✅ All tables
--   ✅ All permissions
--   ✅ All roles with full permissions
--   ✅ All modules
--   ✅ Complete admin user with all permissions
--   ✅ Default configurations
--
-- This is a ONE-FILE setup. Run this ONCE to start fresh.
-- For production, change the admin password immediately!
-- ==============================================================================

-- ==============================================================================
-- PART 1: SAFETY CHECKS & CLEANUP
-- ==============================================================================
-- Optional: Uncomment these lines if you want to drop and recreate everything
-- ⚠️  WARNING: This will DELETE ALL DATA. Use with caution!
-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;
-- COMMENT ON SCHEMA public IS 'standard public schema';

-- ==============================================================================
-- PART 2: CREATE TABLES
-- ==============================================================================

-- 1. Users table
-- Stores system users for authentication
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Roles table
-- Defines system roles (ADMIN, BUILDER, USER, etc.)
CREATE TABLE IF NOT EXISTS roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) UNIQUE NOT NULL,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    parent_role_id UUID REFERENCES roles(id) ON DELETE SET NULL,
    is_system_role BOOLEAN DEFAULT FALSE
);

-- 3. Permissions table
-- Defines granular permissions (READ, WRITE, DELETE, MANAGE, etc.)
CREATE TABLE IF NOT EXISTS permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) UNIQUE NOT NULL,
    description VARCHAR(255),
    category VARCHAR(255) NOT NULL,
    feature_id VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Modules table
-- Defines system modules/features (Forms Management, Workflows, Admin, etc.)
CREATE TABLE IF NOT EXISTS modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_name VARCHAR(255) NOT NULL,
    prefix VARCHAR(255),
    icon_css VARCHAR(255),
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    is_parent BOOLEAN DEFAULT FALSE,
    is_sub_parent BOOLEAN DEFAULT FALSE,
    parent_id UUID REFERENCES modules(id) ON DELETE SET NULL,
    sub_parent_id UUID REFERENCES modules(id) ON DELETE SET NULL,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Role-Permission mapping
-- Links roles to permissions
CREATE TABLE IF NOT EXISTS role_permissions (
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Role-Module mapping
-- Links roles to modules (feature access control)
CREATE TABLE IF NOT EXISTS role_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    module_id UUID NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(role_id, module_id)
);

-- 7. User-Form-Role assignments
-- Maps users to roles for specific forms
CREATE TABLE IF NOT EXISTS user_form_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    form_id UUID,
    assigned_by VARCHAR(255),
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Forms table
-- Main forms metadata
CREATE TABLE IF NOT EXISTS forms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    code VARCHAR(255) UNIQUE NOT NULL,
    status VARCHAR(255) NOT NULL DEFAULT 'DRAFT',
    code_locked BOOLEAN NOT NULL DEFAULT FALSE,
    allow_edit_response BOOLEAN NOT NULL DEFAULT FALSE,
    public_share_token VARCHAR(255) UNIQUE,
    target_table_name VARCHAR(255),
    approval_chain TEXT,
    issued_by_username VARCHAR(255),
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
    creator_id UUID REFERENCES users(id) ON DELETE SET NULL,
    approved_by_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 9. Form Versions table
-- Stores versioned snapshots of forms (immutable)
CREATE TABLE IF NOT EXISTS form_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    form_id UUID NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    change_log TEXT,
    definition_json JSONB NOT NULL,
    rules TEXT,
    activated_by VARCHAR(255),
    activated_at TIMESTAMP WITH TIME ZONE,
    created_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_form_id_version UNIQUE(form_id, version_number)
);

-- 10. Form Fields table
-- Individual field definitions for each form version
CREATE TABLE IF NOT EXISTS form_fields (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    form_version_id UUID NOT NULL REFERENCES form_versions(id) ON DELETE CASCADE,
    field_key VARCHAR(255) NOT NULL,
    label TEXT NOT NULL,
    field_type VARCHAR(255) NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    is_read_only BOOLEAN NOT NULL DEFAULT FALSE,
    is_hidden BOOLEAN NOT NULL DEFAULT FALSE,
    is_disabled BOOLEAN NOT NULL DEFAULT FALSE,
    is_multi_select BOOLEAN NOT NULL DEFAULT FALSE,
    default_value VARCHAR(255),
    help_text TEXT,
    calculation_formula TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    field_options TEXT,
    parent_column_name VARCHAR(255),
    config_json JSONB,
    validation_rules JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_form_version_field UNIQUE(form_version_id, field_key)
);

-- 11. Field Validations table
-- Validation rules for form fields
CREATE TABLE IF NOT EXISTS field_validations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    form_version_id UUID NOT NULL REFERENCES form_versions(id) ON DELETE CASCADE,
    field_key VARCHAR(255),
    validation_type VARCHAR(255) NOT NULL,
    scope VARCHAR(255) NOT NULL,
    expression TEXT NOT NULL,
    error_message TEXT NOT NULL,
    execution_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 12. Form Submission Metadata table
-- Tracks form submissions
CREATE TABLE IF NOT EXISTS form_submission_meta (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    form_id UUID NOT NULL,
    form_version_id UUID NOT NULL,
    submission_table VARCHAR(255) NOT NULL,
    submission_row_id UUID NOT NULL,
    status VARCHAR(255) NOT NULL DEFAULT 'SUBMITTED',
    submitted_by VARCHAR(255),
    submitted_at TIMESTAMP WITH TIME ZONE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 13. Workflow Instances table
-- Approval workflow instances
CREATE TABLE IF NOT EXISTS workflow_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    form_id UUID NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
    creator_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_builder_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(255) DEFAULT 'PENDING',
    total_steps INTEGER,
    current_step_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 14. Workflow Steps table
-- Individual approval steps in a workflow
CREATE TABLE IF NOT EXISTS workflow_steps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID NOT NULL REFERENCES workflow_instances(id) ON DELETE CASCADE,
    approver_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    step_index INTEGER,
    status VARCHAR(255) DEFAULT 'PENDING',
    comments TEXT,
    decided_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 15. Audit Logs table
-- Complete audit trail of all actions
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    action VARCHAR(255) NOT NULL,
    actor VARCHAR(255) NOT NULL,
    resource_type VARCHAR(255),
    resource_id VARCHAR(255),
    details TEXT,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    ip_address VARCHAR(255),
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 16. Level Up Requests table
-- User role elevation requests
CREATE TABLE IF NOT EXISTS level_up_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(255) NOT NULL DEFAULT 'PENDING',
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    decided_by VARCHAR(255),
    decided_at TIMESTAMP WITH TIME ZONE
);

-- 17. System Configurations table
-- System-wide configuration settings
CREATE TABLE IF NOT EXISTS system_configurations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    config_key VARCHAR(255) UNIQUE NOT NULL,
    config_value VARCHAR(255),
    description VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================================================
-- PART 3: CREATE INDEXES FOR PERFORMANCE
-- ==============================================================================

CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);

CREATE INDEX IF NOT EXISTS idx_roles_name ON roles(name);

CREATE INDEX IF NOT EXISTS idx_permissions_name ON permissions(name);
CREATE INDEX IF NOT EXISTS idx_permissions_category ON permissions(category);

CREATE INDEX IF NOT EXISTS idx_modules_module_name ON modules(module_name);

CREATE INDEX IF NOT EXISTS idx_forms_code ON forms(code);
CREATE INDEX IF NOT EXISTS idx_forms_status ON forms(status);
CREATE INDEX IF NOT EXISTS idx_forms_creator_id ON forms(creator_id);
CREATE INDEX IF NOT EXISTS idx_forms_is_deleted ON forms(is_deleted);
CREATE INDEX IF NOT EXISTS idx_forms_public_share_token ON forms(public_share_token);

CREATE INDEX IF NOT EXISTS idx_form_versions_form_id ON form_versions(form_id);
CREATE INDEX IF NOT EXISTS idx_form_versions_is_active ON form_versions(is_active);

CREATE INDEX IF NOT EXISTS idx_form_fields_form_version_id ON form_fields(form_version_id);

CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor ON audit_logs(actor);
CREATE INDEX IF NOT EXISTS idx_audit_logs_resource_type ON audit_logs(resource_type);

CREATE INDEX IF NOT EXISTS idx_user_form_roles_user_id ON user_form_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_form_roles_role_id ON user_form_roles(role_id);

-- ==============================================================================
-- PART 4: SEED PERMISSIONS (9 Core Permissions)
-- ==============================================================================
-- Create permissions: MANAGE, READ, WRITE, EDIT, AUDIT, DELETE, EXPORT, APPROVE, VISIBILITY

INSERT INTO permissions (id, name, description, category, feature_id) VALUES
    ('11111111-1111-1111-1000-000000000001', 'MANAGE', 'Full administrative access', 'System', 'ALL'),
    ('11111111-1111-1111-1000-000000000002', 'READ', 'Read access to resources', 'System', 'ALL'),
    ('11111111-1111-1111-1000-000000000003', 'WRITE', 'Write/Create new resources', 'System', 'ALL'),
    ('11111111-1111-1111-1000-000000000004', 'EDIT', 'Edit existing resources', 'System', 'ALL'),
    ('11111111-1111-1111-1000-000000000005', 'AUDIT', 'Access audit logs', 'System', 'ALL'),
    ('11111111-1111-1111-1000-000000000006', 'DELETE', 'Delete resources', 'System', 'ALL'),
    ('11111111-1111-1111-1000-000000000007', 'EXPORT', 'Export data', 'System', 'ALL'),
    ('11111111-1111-1111-1000-000000000008', 'APPROVE', 'Approval authority', 'System', 'ALL'),
    ('11111111-1111-1111-1000-000000000009', 'VISIBILITY', 'Visibility control', 'System', 'ALL')
ON CONFLICT (name) DO NOTHING;

-- ==============================================================================
-- PART 5: SEED ROLES (4 Core Roles)
-- ==============================================================================

INSERT INTO roles (id, name, description, created_by, is_system_role) VALUES
    ('22222222-2222-2222-2000-000000000001', 'ADMIN', 'System Administrator with full access', 'system', TRUE),
    ('22222222-2222-2222-2000-000000000002', 'ROLE_ADMIN', 'Role Administrator (alias to ADMIN)', 'system', TRUE),
    ('22222222-2222-2222-2000-000000000003', 'BUILDER', 'Form Builder - Can create and publish forms', 'system', TRUE),
    ('22222222-2222-2222-2000-000000000004', 'USER', 'Standard User - Can submit forms', 'system', TRUE)
ON CONFLICT (name) DO NOTHING;

-- ==============================================================================
-- PART 6: MAP ROLE PERMISSIONS (ADMIN gets all permissions)
-- ==============================================================================

INSERT INTO role_permissions (role_id, permission_id) VALUES
    -- ADMIN role gets ALL permissions
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000001'),
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000002'),
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000003'),
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000004'),
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000005'),
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000006'),
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000007'),
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000008'),
    ('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000009'),

    -- ROLE_ADMIN role gets ALL permissions (same as ADMIN)
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000001'),
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000002'),
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000003'),
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000004'),
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000005'),
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000006'),
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000007'),
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000008'),
    ('22222222-2222-2222-2000-000000000002', '11111111-1111-1111-1000-000000000009'),

    -- BUILDER role gets WRITE, EDIT, READ, EXPORT, APPROVE
    ('22222222-2222-2222-2000-000000000003', '11111111-1111-1111-1000-000000000002'),
    ('22222222-2222-2222-2000-000000000003', '11111111-1111-1111-1000-000000000003'),
    ('22222222-2222-2222-2000-000000000003', '11111111-1111-1111-1000-000000000004'),
    ('22222222-2222-2222-2000-000000000003', '11111111-1111-1111-1000-000000000007'),
    ('22222222-2222-2222-2000-000000000003', '11111111-1111-1111-1000-000000000008'),

    -- USER role gets READ and APPROVE
    ('22222222-2222-2222-2000-000000000004', '11111111-1111-1111-1000-000000000002'),
    ('22222222-2222-2222-2000-000000000004', '11111111-1111-1111-1000-000000000008')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- ==============================================================================
-- PART 7: SEED MODULES (3 Core Modules)
-- ==============================================================================

INSERT INTO modules (id, module_name, prefix, icon_css, description, active, is_parent, display_order) VALUES
    ('44444444-4444-4444-4000-000000000001', 'Forms Management', '/forms', 'fas fa-wpforms', 'Create, edit, and publish forms', TRUE, TRUE, 1),
    ('44444444-4444-4444-4000-000000000002', 'Workflows', '/workflows', 'fas fa-project-diagram', 'Manage form approval workflows', TRUE, TRUE, 2),
    ('44444444-4444-4444-4000-000000000003', 'Administration', '/admin', 'fas fa-cogs', 'System administration and configuration', TRUE, TRUE, 3)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- PART 8: MAP ROLE-MODULES (ADMIN and ROLE_ADMIN get all modules)
-- ==============================================================================

INSERT INTO role_modules (id, role_id, module_id) VALUES
    -- ADMIN gets all modules
    ('55555555-5555-5555-5000-000000000001', '22222222-2222-2222-2000-000000000001', '44444444-4444-4444-4000-000000000001'),
    ('55555555-5555-5555-5000-000000000002', '22222222-2222-2222-2000-000000000001', '44444444-4444-4444-4000-000000000002'),
    ('55555555-5555-5555-5000-000000000003', '22222222-2222-2222-2000-000000000001', '44444444-4444-4444-4000-000000000003'),

    -- ROLE_ADMIN gets all modules
    ('55555555-5555-5555-5000-000000000004', '22222222-2222-2222-2000-000000000002', '44444444-4444-4444-4000-000000000001'),
    ('55555555-5555-5555-5000-000000000005', '22222222-2222-2222-2000-000000000002', '44444444-4444-4444-4000-000000000002'),
    ('55555555-5555-5555-5000-000000000006', '22222222-2222-2222-2000-000000000002', '44444444-4444-4444-4000-000000000003'),

    -- BUILDER gets Forms Management and Workflows
    ('55555555-5555-5555-5000-000000000007', '22222222-2222-2222-2000-000000000003', '44444444-4444-4444-4000-000000000001'),
    ('55555555-5555-5555-5000-000000000008', '22222222-2222-2222-2000-000000000003', '44444444-4444-4444-4000-000000000002'),

    -- USER gets Forms Management (read-only)
    ('55555555-5555-5555-5000-000000000009', '22222222-2222-2222-2000-000000000004', '44444444-4444-4444-4000-000000000001')
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- PART 9: CREATE ADMIN USER
-- ==============================================================================
-- ⚠️  IMPORTANT SECURITY NOTE:
--   This creates an admin user with DEFAULT PASSWORD
--
--   Login: admin
--   Default Password: admin@123456
--   Hash: $2b$10$BovrWvKcd5pxIoNQPOoZe.JHOXitasAxkECnJG.BMSKlAx3xaPYs.
--
--   ⚠️  CHANGE THIS PASSWORD IMMEDIATELY IN PRODUCTION!
--   Using bcrypt with salt cost 10.
--
-- To generate a new password hash (bcrypt):
--   Use: https://bcrypt-generator.com/ or your backend auth service
--
-- To change the password after first login:
--   Use the application's change password feature

INSERT INTO users (id, username, password_hash, email, first_name, last_name, is_active, deleted, created_at) VALUES
    ('66666666-6666-6666-6000-000000000001', 'admin', '$2b$10$BovrWvKcd5pxIoNQPOoZe.JHOXitasAxkECnJG.BMSKlAx3xaPYs.', 'admin@formbuilder.local', 'System', 'Administrator', TRUE, FALSE, CURRENT_TIMESTAMP)
ON CONFLICT (username) DO NOTHING;

-- ==============================================================================
-- PART 10: ASSIGN ADMIN USER TO ADMIN ROLE
-- ==============================================================================

INSERT INTO user_form_roles (id, user_id, role_id, assigned_by, assigned_at) VALUES
    ('77777777-7777-7777-7000-000000000001', '66666666-6666-6666-6000-000000000001', '22222222-2222-2222-2000-000000000001', 'system', CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- PART 11: SEED SAMPLE USERS (Optional - for testing)
-- ==============================================================================
-- These are optional test users to help you test different roles
--
-- Passwords (for reference):
--   builder1: $2b$10$oVkF5JvQqjXQJwNxJ2r8Pe.l.yNsKlx5VbJQzQ8rK5x5xQ5x5x5x. (builder@123456)
--   user1:    $2b$10$oVkF5JvQqjXQJwNxJ2r8Pe.l.yNsKlx5VbJQzQ8rK5x5xQ5x5x5x. (user@123456)

INSERT INTO users (id, username, password_hash, email, first_name, last_name, is_active) VALUES
    ('66666666-6666-6666-6000-000000000002', 'builder1', '$2b$10$oVkF5JvQqjXQJwNxJ2r8Pe.l.yNsKlx5VbJQzQ8rK5x5xQ5x5x5x.', 'builder1@formbuilder.local', 'Form', 'Builder', TRUE),
    ('66666666-6666-6666-6000-000000000003', 'user1', '$2b$10$oVkF5JvQqjXQJwNxJ2r8Pe.l.yNsKlx5VbJQzQ8rK5x5xQ5x5x5x.', 'user1@formbuilder.local', 'Standard', 'User', TRUE)
ON CONFLICT (username) DO NOTHING;

-- Assign BUILDER role to builder1
INSERT INTO user_form_roles (id, user_id, role_id, assigned_by) VALUES
    ('77777777-7777-7777-7000-000000000002', '66666666-6666-6666-6000-000000000002', '22222222-2222-2222-2000-000000000003', 'system')
ON CONFLICT (id) DO NOTHING;

-- Assign USER role to user1
INSERT INTO user_form_roles (id, user_id, role_id, assigned_by) VALUES
    ('77777777-7777-7777-7000-000000000003', '66666666-6666-6666-6000-000000000003', '22222222-2222-2222-2000-000000000004', 'system')
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- PART 12: SEED SYSTEM CONFIGURATIONS
-- ==============================================================================

INSERT INTO system_configurations (config_key, config_value, description) VALUES
    ('APP_NAME', 'FormBuilder3', 'Application name'),
    ('APP_VERSION', '1.0.0', 'Application version'),
    ('SESSION_TIMEOUT_MINUTES', '15', 'Session timeout in minutes'),
    ('MAX_FAILED_LOGIN_ATTEMPTS', '5', 'Maximum failed login attempts before lockout'),
    ('PASSWORD_MIN_LENGTH', '8', 'Minimum password length'),
    ('ENABLE_AUDIT_LOGGING', 'true', 'Enable audit logging'),
    ('MAX_FORMS_PER_USER', '100', 'Maximum forms a user can create'),
    ('MAX_FIELDS_PER_FORM', '50', 'Maximum fields per form'),
    ('ALLOW_PUBLIC_FORMS', 'true', 'Allow public form submissions'),
    ('DATABASE_INITIALIZED', 'true', 'Timestamp when database was initialized')
ON CONFLICT (config_key) DO NOTHING;

-- ==============================================================================
-- PART 13: SEED INITIAL AUDIT LOG ENTRY
-- ==============================================================================

INSERT INTO audit_logs (action, actor, resource_type, details) VALUES
    ('DATABASE_INITIALIZED', 'system', 'SYSTEM', 'FormBuilder3 database initialized with schema and seed data')
ON CONFLICT DO NOTHING;

-- ==============================================================================
-- SUMMARY
-- ==============================================================================
-- ✅ Database initialization complete!
--
-- What was created:
--   ✅ 17 core tables
--   ✅ 9 permissions (MANAGE, READ, WRITE, EDIT, AUDIT, DELETE, EXPORT, APPROVE, VISIBILITY)
--   ✅ 4 roles (ADMIN, ROLE_ADMIN, BUILDER, USER)
--   ✅ 3 modules (Forms Management, Workflows, Administration)
--   ✅ Complete permission mapping for all roles
--   ✅ Complete module access for all roles
--   ✅ 1 Admin user (admin / admin@123456)
--   ✅ 2 Sample test users (builder1, user1)
--   ✅ System configurations
--   ✅ Audit log entry
--   ✅ All necessary indexes for performance
--
-- Next steps:
--   1. Change admin password immediately: admin@123456 → secure password
--   2. Create your first form
--   3. Publish and start collecting responses
--
-- For more information:
--   📖 See: sql/README.md
--   🔧 Backend: formbuilder-backend1/README.md
--   🎨 Frontend: formbuilder-frontend1/README.md
-- ==============================================================================
