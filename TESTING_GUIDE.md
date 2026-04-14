# Master Testing Guide: Form Builder End-to-End Verification

This comprehensive guide covers manual testing for the entire Form Builder ecosystem. Follow these steps to verify that every module—from user identity to the dynamic logic engine—is working as expected.

---

## 🛠️ 1. Setup & Environment

Verify that both services are running and communicating correctly.

1. **Backend Service:**
   - Navigate to `formbuilder-backend1`
   - Run: `mvn spring-boot:run`
   - **Verification:** Access `http://localhost:8080/api/v1/forms/stats` (should return JSON or 401).

2. **Frontend Service:**
   - Navigate to `formbuilder-frontend1`
   - Run: `npm run dev`
   - **Verification:** Access `http://localhost:3000`.

3. **Database Check:**
   - Ensure PostgreSQL is running.
   - Verify that tables are created on startup (Check backend logs for `Hibernate: create table...`).

---

## 🔐 2. Identity, RBAC & Profile Suite

Verifies that users can register, login, and that permissions correctly restrict access.

### 2.1 Auth Flow & Session
- [ ] **Registration:** Create a new user at `/register`. Verify email/password validation.
- [ ] **Login:** Log in at `/login`. Verify redirect to Dashboard.
- [ ] **Persistence:** Refresh the page. Verify you remain logged in (Session Cookie test).
- [ ] **Unauthorized Access:** Try to access `/builder` without logging in. Should redirect to `/login`.

### 2.2 Profile & Security
- [ ] **Username Sync:** Change your username in `/profile`.
- [ ] **Auto-Logout:** Verify the system logs you out and requires a re-login with the new username.
- [ ] **Password Change:** Update password. Verify the old password no longer works.

### 2.3 "Level Up" & Role Promotion
- [ ] **Promotion Request:** Login as a standard user (`ROLE_USER`).
- [ ] **Trigger:** Submit a "Level Up" request (found in Profile or sidebar if available).
- [ ] **Admin Approval:** Login as an Admin. Go to **Admin → Approvals**.
- [ ] **Decision:** Approve the request and verify the user now has the `BUILDER` role.

### 2.4 Role-Module Mapping (Menu Visibility)
- [ ] Go to **Admin → Role-Modules**.
- [ ] Remove a module (e.g., "Audit Logs") from the `BUILDER` role.
- [ ] Verify that the "Audit Logs" sidebar item disappears for users with that role.

---

## 🏗️ 3. Form Designer (The Designer)

Verifies the core drag-and-drop experience and schema generation.

### 3.1 Canvas Manipulation
- [ ] **Field Addition:** Add one of every field type (Text, Numeric, Grid, Rating, Scale, Lookup).
- [ ] **Sortable:** Reorder fields using drag-and-drop. Save and reload to verify position persistence.
- [ ] **Nesting:** Drag fields into a `SECTION_HEADER`. Verify they move together.

### 3.2 Field Properties & Auto-Naming
- [ ] **Label to Code:** Create a field "Date of Birth".
- [ ] **Verification:** Open Properties Panel. Verify `columnName` is automatically set to `date_of_birth`.
- [ ] **Immutability:** Save the form. Verify that the "Field Type" becomes locked (grayed out) while others remain editable.

### 3.3 Theme & Aesthetics
- [ ] Open the **Theme Panel**.
- [ ] Change "Primary Color" and "Font Family".
- [ ] Verify the Canvas UI updates instantly (Real-time preview).

---

## 🧠 4. Logic & Rules Engine Suite

Verifies the branching logic and attribute triggers.

### 4.1 Simple Logic (Show/Hide)
- [ ] Create a Radio field "Are you a student?" (Yes/No).
- [ ] Create a Text field "University Name".
- [ ] **Rule:** IF "Are you a student?" IS "Yes" THEN SHOW "University Name".
- [ ] **Test:** In Preview, verify "University Name" is hidden until "Yes" is selected.

### 4.2 Nested Groups & AND/OR
- [ ] Create a rule with a **Condition Group**.
- [ ] **Logic:** IF (Age > 18 AND Has_ID IS True) OR (Parent_Consent IS True).
- [ ] **Verification:** Verify the trigger only fires when the boolean logic is satisfied.

### 4.3 Email & Validation Triggers
- [ ] **Action: SEND_EMAIL:** Verify that a rule can be set to "Send Email Notification" when a condition is met.
- [ ] **Action: REQUIRE:** Set a field to mandatory only if another field has data.

### 4.4 Rename Cascade (Crucial Build Test)
- [ ] Create a field "OldName" and a rule referencing it.
- [ ] Rename "OldName" to "NewName".
- [ ] **Verification:** Re-open the Logic Panel. Verify the rule now automatically refers to `NewName`.

---

## 🚀 5. Form Runtime (Public & Filling)

Verifies that end-users can successfully fill and submit data.

### 5.1 Public Link & Versions
- [ ] **Token Access:** Open the form via the `f/[token]` link in an Incognito window.
- [ ] **Version Mismatch:**
  - Keep the form open in Window A.
  - In Window B, add a field and re-publish the form.
  - **Result:** Window A should show a "Form has been updated" warning banner within 60 seconds.

### 5.2 Complex Data Entry
- [ ] **Grid Testing:** Fill out a `GRID_RADIO` and `GRID_CHECKBOX` field. Verify multiple rows can be selected.
- [ ] **File Upload:**
  - Upload a file > 5MB (Should show error).
  - Upload a 1MB PDF (Should show success).
- [ ] **Calculations:** Create a "Salary" and "Bonus" field. Create a "Total" field with formula `salary + bonus`. Verify "Total" updates live.

### 5.3 Drafts
- [ ] Start filling a form and click "Save Draft".
- [ ] Verification: Close tab, reopen, and verify data persists.

---

## 📊 6. Analytics & Submission Management

Verifies that admin users can consume and manage the collected data.

### 6.1 Data Table View
- [ ] **Sorting:** Click column headers (e.g., `Submitted At`). Verify items reorder.
- [ ] **Global Search:** Type a value found in one row. Verify other rows disappear.
- [ ] **Column Filters:** Use the dropdown filter on a specific column to isolate data.

### 6.2 Data Security (Injection Protection)
- [ ] Submit a response with `=1+1` as a text value.
- [ ] **Export to CSV:** Open the CSV in a text editor.
- [ ] **Verification:** Ensure the value is `'=1+1` (prefixed with single quote) to prevent formula injection.

### 6.3 Exports (Formats)
- [ ] **PDF:** Verify layout is clean and multi-page forms wrap correctly.
- [ ] **XLSX:** Verify all field types (including Grids) export to relevant cells.

### 6.4 Clean & Restore
- [ ] **Soft Delete:** Delete a submission.
- [ ] **Restore:** Go to the Archive/Deleted toggle and restore it. Verify it reappears in the main list.

---

## 🛡️ 7. System Administration & Audit

Verifies the platform's stability and observability.

### 7.1 Audit Trail
- [ ] Delete a Form.
- [ ] Go to **Admin → Audit Logs**.
- [ ] **Verification:** Verify a log entry exists for `DELETE_FORM` with your username and timestamp.

### 7.2 Schema Safety
- [ ] Verify that a form cannot be saved with a reserved SQL keyword as its code (e.g., `INSERT`, `SELECT`).
- [ ] Verify the system handles backend timeouts gracefully with a toast notification.

---

## ✅ Final Build Verification
To consider the build "Production Ready", ensure:
- [ ] `npm run build` passes with 0 errors.
- [ ] All `FIXME` or `TODO` comments in the code have been addressed or triaged.
- [ ] Sidebar icons match the current module list.
