-- ==============================================================================
-- FormBuilder3 - Physical Database Schema (PostgreSQL 14+)
-- ==============================================================================
-- This file creates ONLY the database table structure
-- No data is inserted here - see seeder.sql for that
--
-- USAGE OPTIONS:
--   Option 1 (RECOMMENDED): Use schema-initializer.sql
--     → Creates tables + seeds all necessary data + creates admin user
--     → One command, everything ready
--
--   Option 2: schema.sql then seeder.sql
--     → schema.sql: Creates empty tables
--     → seeder.sql: Adds permissions, roles, admin user
--     → More control, two steps
--
-- To run this file:
--   psql -U postgres formbuilder2 < schema.sql
-- ==============================================================================

-- ==============================================================================
-- TABLE CREATION (IN DEPENDENCY ORDER)
-- ==============================================================================

-- 1. Users table
-- Stores system users for authentication and authorization
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
-- Defines system modules/features (Forms, Workflows, Admin, etc.)
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

-- 5. Role-Permission mapping table
-- Links roles to permissions (who can do what)
CREATE TABLE IF NOT EXISTS role_permissions (
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Role-Module mapping table
-- Links roles to modules (feature access control)
CREATE TABLE IF NOT EXISTS role_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    module_id UUID NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(role_id, module_id)
);

-- 7. User-Form-Role assignments table
-- Maps users to roles for specific forms (fine-grained access control)
CREATE TABLE IF NOT EXISTS user_form_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    form_id UUID,
    assigned_by VARCHAR(255),
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Forms table
-- Main forms metadata and configuration
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
-- Each publish creates a new version with its own database table
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
-- Tracks metadata about form submissions
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
-- Approval workflow instances for forms
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
-- Complete audit trail of all system actions
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
-- User role elevation/permission requests
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
-- CREATE INDEXES FOR PERFORMANCE
-- ==============================================================================
-- These indexes optimize query performance for common operations

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
-- DONE!
-- ==============================================================================
-- Schema created successfully!
--
-- Next steps:
--   1. Run seeder.sql to add permissions, roles, and admin user:
--      psql -U postgres formbuilder2 < seeder.sql
--
--   2. Or use schema-initializer.sql as a one-command setup:
--      psql -U postgres formbuilder2 < schema-initializer.sql
--
-- For more information, see: sql/README.md
-- ==============================================================================
