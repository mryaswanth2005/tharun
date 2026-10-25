# Demo Accounts & Role Verification Guide

The Califnco ecosystem provides pre-configured demo credentials allowing evaluators to immediately inspect all roles and authorization flows without creating new accounts.

---

## 1. Quick Switch in Mobile App
In the Flutter mobile app, you can switch between roles at any time by tapping the **Role Chip** in the top AppBar or visiting **Account -> Switch Demo Role**.

---

## 2. Pre-Configured Demo Accounts Table

| Role | Email | Password | Default Profile Details | What to Test |
| :--- | :--- | :--- | :--- | :--- |
| **Retail Customer** | `customer@califnco.com` | `CustomerPass@123` | **Rahul Sharma**<br>Phone: +91 98765 12345<br>Bengaluru | • Standard retail prices shown across all 52 products<br>• Cart includes 18% GST calculation<br>• Address selection & OpenStreetMap pin<br>• Order placement & tracking |
| **Approved Wholesaler** | `dealer.approved@califnco.com` | `DealerPass@123` | **Apex Water Solutions Ltd**<br>GSTIN: `29ABCDE1234F1Z5`<br>Wholesale Partner Tier | • **25%–40% wholesale discount pricing** active on all 52 items<br>• Wholesale badge shown on product cards<br>• Bulk cart with ₹15,000 minimum order check<br>• Purchase order history |
| **Pending Dealer** | `dealer.pending@califnco.com` | `DealerPass@123` | **Krishna Enterprises**<br>GSTIN: `36AAAAA0000A1Z5`<br>Under Review | • Standard retail prices remain in effect<br>• "Application Under Review" status card shown<br>• In Admin panel, click "Approve" to immediately unlock wholesale tier! |
| **Super Admin** | `admin@califnco.com` | `AdminPass@2026` | **Califnco Admin Ops**<br>Operations Team | • Log in to Next.js dashboard at `http://localhost:3000`<br>• Update order status (Processing -> Dispatched -> Delivered)<br>• Review & approve/reject dealer applications<br>• Assign certified field technicians to service tickets |

---

## 3. Recommended End-to-End Evaluation Scenario
1. **Step 1 (Customer Journey)**: Log in as `customer@califnco.com` in mobile app. Browse the 52 products, filter by `RO water purifiers`, add the AquaPro 10L (₹14,999) to cart, pin delivery address on the OpenStreetMap view, and checkout.
2. **Step 2 (Dealer Price Comparison)**: Switch role to `dealer.approved@califnco.com`. Observe that the AquaPro 10L price drops from ₹14,999 to the wholesale rate of ₹10,500. Add 20 membranes to the bulk cart.
3. **Step 3 (Admin Dispatch)**: Open the Admin Dashboard at `http://localhost:3000`. Notice the newly placed orders on the dashboard. Change the order status to `Dispatched`.
4. **Step 4 (Dealer Review)**: In the Admin Dashboard, navigate to **Dealer Applications**. Find `Krishna Enterprises` under Pending Review. Click **Approve** and record decision notes. Switch to `dealer.pending@califnco.com` to see the wholesale tier immediately unlocked!
5. **Step 5 (Service Dispatch)**: In the mobile app, go to **Services** and book an installation ticket. In the Admin Dashboard, go to **Service Tickets & AMC** and assign engineer `Suresh Kumar`.
