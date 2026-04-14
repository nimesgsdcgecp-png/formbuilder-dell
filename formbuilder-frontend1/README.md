# 🎨 FormBuilder Frontend

**Modern React Frontend for Enterprise Form Builder**  
Built with Next.js, TypeScript, Tailwind CSS, and Zustand State Management

---

## ⚡ Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
npm start
```

**Open:** http://localhost:3000

---

## ✨ Frontend Features

### 🎯 **Form Builder Canvas**
- **Drag-and-drop interface** for building forms visually
- **30+ field types supported** (text, number, date, select, textarea, checkbox, radio, etc.)
- **Real-time preview** - See changes instantly as you build
- **Field configuration panel** - Set labels, validation, placeholder, required status
- **Responsive design** - Works on desktop, tablet, mobile

### 🎨 **Theme & Styling**
- **Color & font customization** per form
- **Pre-built themes** with one-click application
- **Tailwind CSS integration** for consistent styling
- **Responsive grid layout** that adapts to screen size

### 🧠 **Rule Engine UI**
- **Visual rule builder** - IF-THEN conditional logic (no coding needed)
- **Multiple operators** - equals, notEquals, greaterThan, lessThan, contains, startsWith, endsWith
- **Multiple actions** - show, hide, enable, disable, require, clearValue
- **Rule validation** - Client-side validation before saving
- **Real-time evaluation** - Rules apply as user fills form

### 📋 **Form Versioning**
- **Version history panel** - View all published versions
- **Activate/deactivate versions** - Switch which version is public
- **Version comparison** - See what changed between versions
- **Snapshot management** - Each version is immutable

### 🔄 **Workflow & Approval**
- **Workflow initiation modal** - Start approval workflows
- **Approver selection** - Choose who approves
- **Approval status tracking** - See workflow state
- **Comments & decisions** - View approver feedback
- **Audit trail** - Complete history of workflow decisions

### 📤 **Form Publishing & Sharing**
- **One-click publish** - Convert draft to live form
- **Public share links** - Generate unique URLs (/f/token)
- **Copy-to-clipboard** - Easy sharing of public link
- **Share token management** - Regenerate or disable links
- **Public form view** - Unauthenticated submission interface

### 💾 **Form Responses**
- **Response list view** - See all submissions
- **Response detail view** - View individual submission data
- **CSV export** - Download response data
- **Bulk delete & restore** - Manage submissions
- **Soft delete recovery** - Recover deleted responses
- **Response filtering** - Search and sort responses

### 🔐 **Authentication UI**
- **Login page** - Session-based authentication
- **Registration form** - Create new accounts
- **Profile page** - View user details
- **Password management** - Change password
- **Session management** - View active sessions

### 👥 **Admin Features** (for ADMIN role)
- **User management** - Create, edit, deactivate users
- **Role assignment** - Assign ADMIN/MENTOR/INTERN roles
- **Module permissions** - Control feature access
- **Audit logs viewer** - Track all system changes
- **Dashboard analytics** - Forms created, submissions received

### 🏠 **Dashboard**
- **Quick access** to recent forms
- **Quick buttons** - Create form, View responses
- **Form statistics** - Count of forms, responses, workflows
- **Recent activity** - Latest forms and submissions
- **User welcome** - Personalized greeting

### 🛠️ **Developer Features**
- **TypeScript throughout** - Full type safety
- **Zustand state management** - Global form builder state
- **API client wrapper** - Centralized API calls (src/services/api.ts)
- **Environment configuration** - Easy .env setup
- **Error boundaries** - Graceful error handling
- **Loading states** - Proper async feedback

---

## 📁 Frontend Project Structure

```
formbuilder-frontend1/
├── app/                              # Next.js App Router pages
│   ├── page.tsx                      # Dashboard home page
│   ├── layout.tsx                    # Root layout with navbar
│   ├── login/page.tsx                # Login page
│   ├── register/page.tsx             # Registration page
│   ├── profile/page.tsx              # User profile page
│   │
│   ├── builder/
│   │   ├── page.tsx                  # Form builder with canvas
│   │   └── preview/page.tsx          # Form preview/test page
│   │
│   ├── forms/[id]/
│   │   ├── page.tsx                  # Form details
│   │   └── responses/page.tsx        # View form responses
│   │
│   ├── f/[token]/page.tsx            # Public form submission (no auth)
│   │
│   └── admin/
│       ├── users/page.tsx            # User management
│       ├── roles/page.tsx            # Role management
│       └── audit/page.tsx            # Audit logs viewer
│
├── components/                       # Reusable React components
│   ├── builder/
│   │   ├── Canvas.tsx               # Main editing area (drag-drop)
│   │   ├── Sidebar.tsx              # Field types palette
│   │   ├── PropertiesPanel.tsx      # Selected field config
│   │   ├── LogicPanel.tsx           # Rule builder UI
│   │   ├── VersionsPanel.tsx        # Version history
│   │   └── PublishModal.tsx         # Publish confirmation
│   │
│   ├── FormRenderer.tsx             # Display form for submission
│   ├── FieldRenderer.tsx            # Individual field display
│   ├── Navbar.tsx                   # Top navigation
│   ├── Sidebar.tsx                  # Left sidebar menu
│   └── ...other shared components
│
├── store/                           # Zustand state management
│   ├── useFormStore.ts              # Form being edited
│   ├── useUIStore.ts                # UI state (panels, modals)
│   └── useAuthStore.ts              # User auth & permissions
│
├── services/
│   ├── api.ts                       # API client wrapper
│   └── ...domain-specific services
│
├── utils/
│   ├── apiConstants.ts              # API endpoints & paths
│   ├── validators.ts                # Field validation logic
│   └── ...utility functions
│
├── styles/
│   └── globals.css                  # Global styles & Tailwind
│
├── public/                          # Static assets
│   └── ...images, icons
│
├── .env.local                       # Environment variables (gitignored)
├── package.json                     # Dependencies
├── tsconfig.json                    # TypeScript config
├── tailwind.config.ts               # Tailwind CSS config
├── next.config.ts                   # Next.js config
└── README.md                        # This file
```

---

## 🛠️ Technology Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| **Next.js** | 16.1.6 | React framework with SSR |
| **React** | 19.2 | UI library |
| **TypeScript** | Latest | Type safety |
| **Zustand** | 5.0.11 | State management |
| **Tailwind CSS** | 4.2.1 | Utility-first styling |
| **@dnd-kit** | Latest | Drag-and-drop |
| **Axios** | Latest | HTTP client |
| **React Hook Form** | Latest | Form handling |

---

## 🔄 State Management (Zustand)

### Form Store (`useFormStore`)
```typescript
{
  // Current form being built
  form: {
    id, title, description, fields, rules, status
  },
  
  // Actions
  setForm,
  addField,
  updateField,
  removeField,
  updateRule,
  publishForm
}
```

### UI Store (`useUIStore`)
```typescript
{
  // UI state
  activePanel,      // 'properties', 'logic', 'versions'
  selectedFieldId,  // Currently selected field
  showPublishModal, // Publish confirmation
  
  // Actions
  setActivePanel,
  selectField,
  togglePublishModal
}
```

---

## 🔌 API Integration

All API calls go through centralized constants:

```typescript
// Frontend API constants (src/utils/apiConstants.ts)
export const API_ENDPOINTS = {
  AUTH: {
    LOGIN: '/api/v1/auth/login',
    LOGOUT: '/api/v1/auth/logout',
    ME: '/api/v1/auth/me'
  },
  FORMS: {
    LIST: '/api/v1/forms',
    GET: (id) => `/api/v1/forms/${id}`,
    CREATE: '/api/v1/forms',
    UPDATE: (id) => `/api/v1/forms/${id}`,
    PUBLISH: (id) => `/api/v1/forms/${id}/publish`
  },
  RUNTIME: {
    SUBMIT: '/api/v1/runtime/submit',
    DRAFTS: '/api/v1/runtime/drafts'
  }
}
```

---

## 📲 Key Pages

### Dashboard (`/`)
- Welcome message
- Quick actions (Create Form, View Forms)
- Recent forms list
- Statistics

### Form Builder (`/builder`)
- Drag-drop canvas
- Field sidebar
- Properties panel
- Logic panel (rules)
- Versions panel
- Publish button

### Form Responses (`/forms/:id/responses`)
- List all submissions
- Search/filter
- Export to CSV
- View individual response
- Delete/restore

### Public Form (`/f/:token`)
- No authentication required
- Form submission interface
- Validation feedback
- Success message

### Admin Panel (`/admin/*`)
- User management
- Role assignment
- Audit logs
- System settings

---

## 🚀 Development Commands

```bash
# Install dependencies
npm install

# Start dev server (with hot reload)
npm run dev

# Build for production
npm run build

# Start production server
npm start

# Run linter
npm run lint

# Format code
npm run format
```

---

## 🔐 Security Features

- ✅ Session-based authentication
- ✅ CSRF protection (via SameSite cookies)
- ✅ XSS prevention (React auto-escaping)
- ✅ Input validation (client & server)
- ✅ Safe API calls (no hardcoded secrets)
- ✅ Protected routes (authentication guard)

---

## 📱 Responsive Design

- **Mobile-first approach** with Tailwind CSS
- **Breakpoints:** sm (640px), md (768px), lg (1024px), xl (1280px)
- **Touch-friendly** form builder even on tablets
- **Adaptive layouts** that work on all screen sizes

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Port 3000 in use | Run on different port: `npm run dev -- -p 3001` |
| API not responding | Check backend is running on :8080 |
| Styles not loading | Clear .next: `rm -rf .next && npm run dev` |
| TypeScript errors | Run `npm run build` to see full errors |
| State not persisting | Check Zustand store initialization |

---

## 📞 Need Help?

- Check parent project [README.md](../README.md)
- Review [ARCHITECTURE.md](../ARCHITECTURE.md) for system overview
- See [SECURITY_AUDIT.md](../SECURITY_AUDIT.md) for security questions

---

**Last Updated:** April 2026  
**Status:** Production-Ready  
**Maintainer:** STTL
