-- ==============================================================================
-- FormBuilder3 - Core Database Seeder
-- Includes 6 UI mapped Permissions and core roles.
-- ==============================================================================

-- 1. Seed Permissions (READ, EDIT, WRITE, AUDIT, MANAGE, DELETE)
INSERT INTO permissions (id, name, description, category, feature_id) VALUES 
('11111111-1111-1111-1000-000000000001', 'MANAGE', 'Full administrative access', 'System', 'ALL'),
('11111111-1111-1111-1000-000000000002', 'READ', 'Read access', 'System', 'ALL'),
('11111111-1111-1111-1000-000000000003', 'WRITE', 'Write access', 'System', 'ALL'),
('11111111-1111-1111-1000-000000000004', 'EDIT', 'Edit access', 'System', 'ALL'),
('11111111-1111-1111-1000-000000000005', 'AUDIT', 'Audit logs access', 'System', 'ALL'),
('11111111-1111-1111-1000-000000000006', 'DELETE', 'Delete access', 'System', 'ALL'),
('11111111-1111-1111-1000-000000000007', 'EXPORT', 'Export data access', 'System', 'ALL'),
('11111111-1111-1111-1000-000000000008', 'APPROVE', 'Approval access', 'System', 'ALL'),
('11111111-1111-1111-1000-000000000009', 'VISIBILITY', 'Visibility control access', 'System', 'ALL')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- 2. Seed Roles (ADMIN, ROLE_ADMIN, USER, BUILDER)
INSERT INTO roles (id, name, description, created_by, created_at, parent_role_id) VALUES 
('22222222-2222-2222-2000-000000000001', 'ADMIN', 'System Administrator', 'system', CURRENT_TIMESTAMP, NULL),
('22222222-2222-2222-2000-000000000002', 'ROLE_ADMIN', 'System Administrator Alias', 'system', CURRENT_TIMESTAMP, NULL),
('22222222-2222-2222-2000-000000000003', 'USER', 'Standard User', 'system', CURRENT_TIMESTAMP, NULL),
('22222222-2222-2222-2000-000000000004', 'BUILDER', 'Form Builder', 'system', CURRENT_TIMESTAMP, NULL)
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- 3. Seed Role-Permissions Mapping (ADMIN gets all)
INSERT INTO role_permissions (role_id, permission_id) VALUES 
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000001'),
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000002'),
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000003'),
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000004'),
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000005'),
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000006'),
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000007'),
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000008'),
('22222222-2222-2222-2000-000000000001', '11111111-1111-1111-1000-000000000009')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- 4. Seed Modules
INSERT INTO modules (id, module_name, prefix, icon_css, active, is_parent, is_sub_parent, parent_id, sub_parent_id, created_at) VALUES 
('44444444-4444-4444-4000-000000000001', 'Forms Management', '/forms', 'fas fa-wpforms', true, true, false, NULL, NULL, CURRENT_TIMESTAMP),
('44444444-4444-4444-4000-000000000002', 'Workflows', '/workflows', 'fas fa-project-diagram', true, true, false, NULL, NULL, CURRENT_TIMESTAMP),
('44444444-4444-4444-4000-000000000003', 'Administration', '/admin', 'fas fa-cogs', true, true, false, NULL, NULL, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO UPDATE SET module_name = EXCLUDED.module_name;

-- 5. Seed Role-Modules Mapping (ADMIN gets all modules)
INSERT INTO role_modules (id, role_id, module_id) VALUES 
('55555555-5555-5555-5000-000000000001', '22222222-2222-2222-2000-000000000001', '44444444-4444-4444-4000-000000000001'),
('55555555-5555-5555-5000-000000000002', '22222222-2222-2222-2000-000000000001', '44444444-4444-4444-4000-000000000002'),
('55555555-5555-5555-5000-000000000003', '22222222-2222-2222-2000-000000000001', '44444444-4444-4444-4000-000000000003')
ON CONFLICT (id) DO NOTHING;

-- 6. Seed Users
INSERT INTO users (id, username, password_hash, deleted, created_at) VALUES 
('66666666-6666-6666-6000-000000000001', 'admin', '$2b$10$BovrWvKcd5pxIoNQPOoZe.JHOXitasAxkECnJG.BMSKlAx3xaPYs.', false, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO UPDATE SET password_hash = EXCLUDED.password_hash;

-- 7. Manage System User Role Assignment
INSERT INTO user_form_roles (id, user_id, role_id, form_id, assigned_by, assigned_at) VALUES 
('77777777-7777-7777-7000-000000000001', '66666666-6666-6666-6000-000000000001', '22222222-2222-2222-2000-000000000001', NULL, 'system', CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;
