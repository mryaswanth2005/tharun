# Califnco Architecture & Systems Overview

## 1. System Ecosystem

The Califnco solution is built as a complete, zero-cost-ready commercial ecosystem for drinking water purifiers, commercial plants, and replacement filter spares.

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        CALIFNCO ECOSYSTEM ARCHITECTURE                 │
└────────────────────────────────────────────────────────────────────────┘

 [ Customers & Wholesale Dealers ]               [ Operations & Admins ]
                │                                           │
                ▼                                           ▼
   ┌───────────────────────────┐               ┌───────────────────────────┐
   │    Android Mobile App     │               │     Admin Dashboard       │
   │  (Flutter 3.47 + Riverpod)│               │  (Next.js 16 + Tailwind)  │
   │                           │               │                           │
   │ • 52-Product Catalog      │               │ • Executive Sales Metrics │
   │ • Wholesale Pricing Tier  │               │ • Order Dispatch Pipeline │
   │ • Razorpay Test Checkout  │               │ • Dealer Compliance Review│
   │ • OpenStreetMap Pinning   │               │ • Technician Dispatcher   │
   │ • Service & AMC Tickets   │               │ • 52-Item Inventory Mgmt  │
   └─────────────┬─────────────┘               └─────────────┬─────────────┘
                 │                                           │
                 │              Cloud Firestore              │
                 ├───────────────────────────────────────────┤
                 │ • users           • orders                │
                 │ • products (52)   • dealerApplications    │
                 │ • carts           • serviceBookings       │
                 │ • addresses       • appSettings           │
                 └─────────────────────┬─────────────────────┘
                                       │
                                       ▼
                       ┌───────────────────────────────┐
                       │   n8n Marketing Automation    │
                       │   (Self-Hosted or Cloud)      │
                       │                               │
                       │ 1. Read Google Sheets Queue   │
                       │ 2. Gemini 1.5 Caption/Tags    │
                       │ 3. Hugging Face/CDN Visual    │
                       │ 4. Meta Instagram Graph API   │
                       │ 5. Optional WAHA Status Story │
                       └───────────────────────────────┘
```

---

## 2. Component Breakdown

### A. Mobile Application (`/mobile`)
- **Framework**: Flutter 3.47 / Dart 3.13.
- **State Management**: Riverpod (`flutter_riverpod: 2.6.1`) utilizing StateNotifiers and Providers.
- **Navigation**: `go_router` featuring a 5-tab ShellRoute (`Catalog`, `Orders`, `Services`, `Wholesale`, `Account`) and deep-linked detail routes.
- **Role Modes**:
  - **Customer**: Standard retail pricing with 18% GST calculation.
  - **Wholesale Dealer (Approved)**: 25% to 40% margin discount across all 52 products, wholesale bulk cart, and ₹15,000 bulk threshold check.
  - **Wholesale Dealer (Pending)**: Real-time "Application Under Review" compliance card.
- **Mapping & Geocoding**: OpenStreetMap interactive visual pin picker using `flutter_map: 7.0.2` and `latlong2`.
- **Payment Gateway**: Razorpay test-mode integration with pre-built duplicate payment protection and verified sandbox fallback.

### B. Admin Dashboard (`/admin`)
- **Framework**: Next.js 16 (App Router) + TypeScript.
- **Styling**: Tailwind CSS with Califnco Navy (`#0A192F`), Slate neutral surfaces, and Aqua accents.
- **Operational Modules**:
  1. **Overview**: Executive metric cards (Gross revenue, fulfillment counters, pending dealer badges, low stock alerts).
  2. **Order Management**: Search, filter by status (Placed -> Confirmed -> Processing -> Dispatched -> Delivered), interactive lifecycle updater, invoice drawer.
  3. **Dealer Applications**: Compliance review of GSTIN credentials, recorded decision audit log, instant authorization of wholesale pricing.
  4. **Field Service & AMC**: Service ticket tracking, certified technician dispatcher (South, North, East, Central zones), status updates.
  5. **Product & Inventory**: Searchable master table of 52 seeded products across 10 categories with customer vs wholesale comparisons.

### C. AI Marketing Automation (`/automation`)
- **Engine**: n8n workflow scheduled daily at 09:00 AM IST.
- **Queue**: Google Sheets with 52 seeded products and status lifecycle (`pending` -> `processing` -> `published`).
- **AI Copywriting**: Gemini 1.5 Flash producing factual specifications and 8-12 hashtags without invented claims.
- **AI Visuals**: Hugging Face Inference API / FLUX commercial packshot prompts uploaded to Cloudinary CDN meeting Meta 1:1 Instagram requirements.
- **Publishing**: Meta Instagram Graph API container creation and publication, with zero-setup dry-run simulation mode.
- **Bonus**: WAHA WhatsApp Status automation workflow.
