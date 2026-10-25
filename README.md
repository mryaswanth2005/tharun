# Califnco Water Purifier E-Commerce & AI Automation Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.47.0-blue.svg)](https://flutter.dev)
[![Next.js](https://img.shields.io/badge/Next.js-16.4.3-black.svg)](https://nextjs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue.svg)](https://www.typescriptlang.org)
[![n8n](https://img.shields.io/badge/n8n-Workflow-orange.svg)](https://n8n.io)
[![Test Suite](https://img.shields.io/badge/Tests-Passing-brightgreen.svg)]()
[![Zero Cost](https://img.shields.io/badge/Zero--Cost-Tier--Optimized-teal.svg)]()

> Complete, production-structured software ecosystem built for the **Califnco Software Developer Round 1 Technical Assignment**.
> Delivers an Android e-commerce application for water purifiers, a SaaS Operations Admin Dashboard, and an automated daily AI Instagram marketing pipeline.

---

## 1. Deliverables Summary

| Deliverable | Technology Stack | Location | Status |
| :--- | :--- | :--- | :---: |
| **Android Mobile Application** | Flutter 3.47, Dart 3.13, Riverpod 2.6, GoRouter, OpenStreetMap, Razorpay Test | `/mobile` | ✅ Complete & Tested |
| **Admin Operations Dashboard** | Next.js 16 (App Router), TypeScript, Tailwind CSS, Lucide Icons | `/admin` | ✅ Production Build Verified |
| **AI Instagram Marketing Automation** | n8n, Google Sheets Queue, Gemini 1.5, Hugging Face, Cloudinary, Meta Graph API | `/automation` | ✅ Verified with Simulator |
| **Database & Security Architecture** | Cloud Firestore Schema, Production Security Rules, Compound Indexes | `/backend` | ✅ Documented & Seeded |
| **52-Product Realistic Catalog** | 52 products across 10 categories with customer & wholesale pricing | `backend/data/` | ✅ 52 Items Seeded |
| **Bonus WhatsApp Status Workflow** | n8n + WAHA Docker HTTP API workflow | `/automation/workflows` | ✅ Included |

---

## 2. System Architecture

```text
tharun/
├── mobile/                   # Android Flutter Mobile E-Commerce App
│   ├── lib/
│   │   ├── app/              # Theme, GoRouter, shell bottom navigation
│   │   ├── core/             # Constants, colors, formatting, mock sessions
│   │   ├── shared/           # ProductCard, StatusBadge, EmptyState widgets
│   │   └── features/         # Feature-first modular structure
│   │       ├── auth/         # Customer, Dealer, Admin authentication
│   │       ├── catalog/      # 52 products, 10 categories, search, sorting
│   │       ├── cart/         # Subtotal, 18% GST, free shipping, wholesale limits
│   │       ├── checkout/     # Razorpay test mode, OpenStreetMap location picker
│   │       ├── orders/       # Order tracking timeline (Placed -> Delivered)
│   │       ├── services/     # Installation, repairs, AMC booking & tracking
│   │       ├── dealer/       # Wholesale bulk ordering & GST application
│   │       └── profile/      # Saved GPS addresses & demo role switcher
│   └── test/                 # Automated unit & widget tests
├── admin/                    # Next.js 16 SaaS Operations Dashboard
│   ├── src/
│   │   ├── app/
│   │   │   ├── page.tsx      # Executive command center & sales metrics
│   │   │   ├── orders/       # Order fulfillment & status updater
│   │   │   ├── dealers/      # Dealer GST compliance review & authorization
│   │   │   ├── services/     # Field service ticket & technician dispatcher
│   │   │   ├── products/     # Master 52-product inventory & specs inspector
│   │   │   └── login/        # Admin authentication with one-click auto-fill
│   │   ├── components/       # SaaS Sidebar, Header, Status Badges
│   │   └── lib/              # Persistent data store & domain TypeScript types
├── automation/               # n8n AI Marketing Automation
│   ├── workflows/            # n8n workflow JSONs (Instagram + WhatsApp)
│   ├── prompts/              # Gemini caption & Hugging Face visual prompts
│   ├── sheets_template/      # 52-product Google Sheets queue CSV
│   └── test_runner/          # Local simulation test harness
├── backend/                  # Shared backend rules & seed scripts
│   ├── firestore.rules       # Role-based security rules
│   ├── firestore.indexes.json# Compound query indexes
│   ├── data/products.json    # 52 seeded products across 10 categories
│   └── scripts/              # Firestore seed script & CSV exporter
└── docs/                     # Comprehensive technical documentation guides
```

---

## 3. Quick Start Guide

### A. Run Mobile App (Flutter)
```bash
cd mobile
flutter pub get
flutter test       # Runs automated test suite (5/5 passed)
flutter analyze    # Verifies zero static analysis errors
flutter run        # Launches on Android device/emulator or Web
```

### B. Run Admin Dashboard (Next.js)
```bash
cd admin
npm install
npm run build      # Verifies static compilation & type checking
npm run dev        # Launches on http://localhost:3000
```

### C. Run AI Marketing Automation Simulator
```bash
node automation/test_runner/simulate_workflow.js
```

---

## 4. Evaluator Demo Accounts

The app and admin dashboard provide pre-configured demo credentials for instant testing:

| Role | Email | Password | What You Can Test |
| :--- | :--- | :--- | :--- |
| **Retail Customer** | `customer@califnco.com` | `CustomerPass@123` | Retail prices across all 52 products, cart calculations with 18% GST, OpenStreetMap delivery pin, order history. |
| **Approved Wholesaler** | `dealer.approved@califnco.com` | `DealerPass@123` | **25%–40% wholesale discount pricing active**, wholesale badge, bulk cart, ₹15,000 bulk threshold check. |
| **Pending Dealer** | `dealer.pending@califnco.com` | `DealerPass@123` | Retail pricing active, "Application Under Review" compliance card. |
| **Super Admin** | `admin@califnco.com` | `AdminPass@2026` | Admin operations panel at `http://localhost:3000`, order dispatch, dealer approvals, technician assignments. |

*In the mobile app, tap the **Role Chip** in the top AppBar to switch between these roles with one tap.*

---

## 5. Catalog Categories (52 Realistic Seeded Products)

Every product includes unique SKU, category, customer retail price, lower wholesale dealer price, real-time stock, complete technical specifications, and matching photography:

1. **RO water purifiers** (5 models)
2. **UV water purifiers** (5 models)
3. **UF water purifiers** (5 models)
4. **Commercial water purification systems** (5 models: 50 LPH, 100 LPH, 250 LPH, Softeners, Coolers)
5. **Water dispensers** (5 models: Bottom load, Tabletop, Plumbed-In POU, Refrigerated)
6. **Water pumps** (5 models: 75 GPD, 100 GPD, 150 GPD, 300 GPD Commercial, 24V SMPS)
7. **RO membranes** (5 models: High TDS 75 GPD, Dow 80 GPD, Low Energy 100 GPD, Commercial 300 GPD, 4040 Industrial)
8. **Sediment filters** (5 models: Spun 5-Micron 3-Pack, String Wound, Washable Pleated, Jumbo 20-inch, Inline)
9. **Carbon filters** (5 models: CTO Block, GAC Granular, Silver Nano Polisher, Jumbo Commercial, Copper & Zinc)
10. **Replacement cartridges & spare parts** (7 models: Pre-Filter Housing, Solenoid Valve, Flow Restrictor, Membrane Housing, PE Tubing, Overhaul Kit, Digital TDS Meter)

---

## 6. Comprehensive Documentation Directory

Detailed guides are available in the `/docs` directory:
- [Architecture & Systems Overview](docs/architecture_overview.md)
- [Firestore Schema Documentation](docs/firestore_schema.md)
- [Firebase Security Rules & Role Strategy](docs/firebase_security_rules.md)
- [Environment Variables Reference](docs/environment_variables.md)
- [Seed Data Instructions](docs/seed_data_instructions.md)
- [Local Development Instructions](docs/local_development_instructions.md)
- [Android Build Instructions](docs/android_build_instructions.md)
- [Vercel Deployment Instructions](docs/vercel_deployment_instructions.md)
- [n8n Workflow Setup Guide](docs/n8n_workflow_setup_guide.md)
- [Meta Instagram Graph API Setup Guide](docs/instagram_api_setup_guide.md)
- [Demo Accounts & Role Verification Guide](docs/demo_accounts_guide.md)
- [Test Plan, Verification Matrix & Limitations](docs/test_plan_and_limitations.md)
- [Submission Screenshots Checklist](docs/screenshots_checklist.md)

---

## 7. License & Compliance
This software was engineered for the Califnco Software Developer Round 1 Technical Assignment. Built using zero-cost eligible services and industry best practices.
