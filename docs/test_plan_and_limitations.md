# Test Plan, Verification Matrix & Known Limitations

## 1. Test Verification Matrix (16 Acceptance Criteria)

| # | Test Scenario / Acceptance Criterion | Implementation Details | Result |
| :---: | :--- | :--- | :---: |
| 1 | **Customer Registration & Login** | Handled by `AuthRepository` with Firebase Auth and offline demo caching | ✅ PASSED |
| 2 | **52-Product Catalog with Matching Images** | 52 products across 10 categories with authentic specs, pricing & photos | ✅ PASSED |
| 3 | **Search & Category Filtering** | Real-time reactive query provider with instant 10-category chip scrolling | ✅ PASSED |
| 4 | **Cart Calculations & GST** | Subtotal, 18% GST, free shipping (> ₹999), and wholesale minimum check | ✅ PASSED (Verified via `flutter test`) |
| 5 | **Checkout Lifecycle Handling** | Razorpay test mode, duplicate-payment protection, and sandbox mode | ✅ PASSED |
| 6 | **Order Tracking & Admin Sync** | Visual shipment timeline (Placed -> Delivered) synced with Admin panel | ✅ PASSED |
| 7 | **Dealer Approval & Rejection Flow** | Admin can approve or reject with recorded decision notes | ✅ PASSED |
| 8 | **Wholesale Gating Enforcement** | Only dealers with `dealerStatus == 'approved'` obtain wholesale prices | ✅ PASSED (Verified via `flutter test`) |
| 9 | **Dealer Pricing Lower Than Retail** | Every product features lower wholesale dealer price (up to 35% discount) | ✅ PASSED (Verified via `flutter test`) |
| 10 | **Service Booking & Field Dispatch** | Booking form (installation, AMC, filter replacement) + technician dispatcher | ✅ PASSED |
| 11 | **Backend Role-Based Security Rules** | Rules prevent client-side role tampering and unauthorized wholesale orders | ✅ PASSED |
| 12 | **Admin Dashboard Production Build** | Next.js 16 App Router builds statically with 0 errors via `npm run build` | ✅ PASSED |
| 13 | **n8n Schedule & Google Sheets Queue** | Daily 09:00 AM cron trigger reading and locking product queue | ✅ PASSED |
| 14 | **Factual AI Captions & Visuals** | Gemini prompt uses strict product specs without hallucinations | ✅ PASSED |
| 15 | **Meta Instagram Graph API Publishing** | Container creation and publication with automated Dry-Run fallback | ✅ PASSED (Verified via `simulate_workflow.js`) |
| 16 | **Duplicate Publishing Prevention** | Stable product ID and queue state locking to `processing` / `published` | ✅ PASSED |

---

## 2. Automated Test Suite Execution
Run tests in `mobile/`:
```bash
flutter test
```
Result:
```text
00:00 +0: ProductModel & Wholesale Pricing Tests Regular customer sees retail selling price
00:00 +1: ProductModel & Wholesale Pricing Tests Approved dealer sees wholesale discount price
00:00 +2: Cart Calculations & Wholesale Threshold Tests Calculates subtotal, 18% GST, and shipping correctly for retail customer
00:00 +3: Cart Calculations & Wholesale Threshold Tests Enforces minimum ₹15,000 threshold for wholesale bulk orders
00:00 +4: UserModel Role & Security Tests Correctly identifies approved vs pending vs customer
00:00 +5: All tests passed!
```

---

## 3. Known Limitations & Zero-Cost Assumptions
1. **SMS Gateway**: Production SMS OTP in India requires DLT (Distributed Ledger Technology) registration and paid TRAI telecom gateway accounts. In accordance with assignment instructions, simulated OTP and verified Email notification hooks are utilized.
2. **Meta Instagram Graph API Quota**: Publishing to official Instagram via Graph API requires a Meta Business Verification review. The workflow includes a fully tested **Dry-Run Mode** that simulates Meta container creation and publication without requiring a live token.
3. **OpenStreetMap Tiles**: OpenStreetMap tile servers are free of cost. High-frequency enterprise deployments should configure an API key with Stadia Maps or Mapbox.
