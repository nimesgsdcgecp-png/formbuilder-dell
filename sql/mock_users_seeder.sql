-- ==============================================================================
-- FormBuilder3 - Mock Users Seeder
-- Specifically deploys ROLE_ADMINISTRATOR and a mock user for each available role.
-- Requires seeder.sql to be run first.
-- ==============================================================================

-- 1. Seed ROLE_ADMINISTRATOR
INSERT INTO roles (id, name, description, created_by, created_at, parent_role_id) VALUES 
('22222222-2222-2222-2000-000000000005', 'ROLE_ADMINISTRATOR', 'Secondary Admin Alias', 'system', CURRENT_TIMESTAMP, NULL)
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- 2. Seed Extra Mock Users
-- Uses password: password123
INSERT INTO users (id, username, password_hash, deleted, created_at) VALUES 
('66666666-6666-6666-6000-000000000002', 'role_admin_user', '$2b$10$BovrWvKcd5pxIoNQPOoZe.JHOXitasAxkECnJG.BMSKlAx3xaPYs.', false, CURRENT_TIMESTAMP),
('66666666-6666-6666-6000-000000000003', 'user', '$2b$10$BovrWvKcd5pxIoNQPOoZe.JHOXitasAxkECnJG.BMSKlAx3xaPYs.', false, CURRENT_TIMESTAMP),
('66666666-6666-6666-6000-000000000004', 'builder', '$2b$10$BovrWvKcd5pxIoNQPOoZe.JHOXitasAxkECnJG.BMSKlAx3xaPYs.', false, CURRENT_TIMESTAMP),
('66666666-6666-6666-6000-000000000005', 'role_administrator_user', '$2b$10$BovrWvKcd5pxIoNQPOoZe.JHOXitasAxkECnJG.BMSKlAx3xaPYs.', false, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO UPDATE SET password_hash = EXCLUDED.password_hash;

-- 3. Assign Roles to Mock Users
INSERT INTO user_form_roles (id, user_id, role_id, form_id, assigned_by, assigned_at) VALUES 
('77777777-7777-7777-7000-000000000002', '66666666-6666-6666-6000-000000000002', '22222222-2222-2222-2000-000000000002', NULL, 'system', CURRENT_TIMESTAMP),
('77777777-7777-7777-7000-000000000003', '66666666-6666-6666-6000-000000000003', '22222222-2222-2222-2000-000000000003', NULL, 'system', CURRENT_TIMESTAMP),
('77777777-7777-7777-7000-000000000004', '66666666-6666-6666-6000-000000000004', '22222222-2222-2222-2000-000000000004', NULL, 'system', CURRENT_TIMESTAMP),
('77777777-7777-7777-7000-000000000005', '66666666-6666-6666-6000-000000000005', '22222222-2222-2222-2000-000000000005', NULL, 'system', CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;
