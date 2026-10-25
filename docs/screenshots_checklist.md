# Submission Screenshots & Demonstration Checklist

Use this checklist when capturing screenshots or screen recordings for final submission.

---

## 1. Mobile Android App (`/mobile`)

- [ ] **1. Product Catalog**: Showing multiple categories, search bar, active category chip, and product cards with prices in INR.
- [ ] **2. Wholesale Tier Comparison**: Showing the exact same product (e.g. `Califnco AquaPro RO 10L`) as Customer (₹14,999) vs Approved Dealer (₹10,500 with Wholesale Badge).
- [ ] **3. Product Details Screen**: Specifications table, stock counter, and quantity selector.
- [ ] **4. Shopping Cart**: Showing item quantities, subtotal, 18% GST breakdown, and Free Express Delivery.
- [ ] **5. OpenStreetMap Address Pinning**: Map view with pin marker showing coordinates in Bangalore / Hyderabad.
- [ ] **6. Razorpay / Simulated Checkout**: Payment method options (Razorpay Test Mode, Simulated Verified, COD).
- [ ] **7. Order Confirmation & Timeline**: Success screen showing Order Number (e.g. `CAL-ORD-9412`) and visual tracking timeline (Placed -> Dispatched -> Delivered).
- [ ] **8. Service / AMC Booking**: Service request form (Installation, Filter overhaul, AMC) with date/slot picker.
- [ ] **9. Dealer Wholesale Portal**: Authorized partner overview showing GSTIN, active wholesale discount tier, and bulk catalog access.
- [ ] **10. Pending Dealer Status**: Application under review status card with GST verification notice.

---

## 2. Admin Operations Dashboard (`/admin`)

- [ ] **11. Dashboard Overview**: Executive metric cards (Gross revenue in INR, Active orders, Wholesalers count, Open service tickets) and Recent Orders table.
- [ ] **12. Order Management**: Filtered orders table with status updater dropdown and Order Details drawer.
- [ ] **13. Order Cancellation Confirmation**: Modal dialog confirming consequential cancellation action.
- [ ] **14. Dealer Applications Compliance**: Tabbed view showing Pending applications with GSTIN badges.
- [ ] **15. Dealer Decision Modal**: Recorded decision notes dialog for approving/rejecting dealership applications.
- [ ] **16. Service & AMC Dispatcher**: Service tickets list with technician assignment modal.
- [ ] **17. Product Master Table**: 52 seeded products across 10 categories with customer vs wholesale dealer price comparisons.

---

## 3. AI Marketing Automation (`/automation`)

- [ ] **18. n8n Visual Workflow**: 13-node visual canvas showing schedule trigger, Google Sheets queue reader, Gemini AI caption generator, Hugging Face image node, Cloudinary CDN node, and Meta Graph API node.
- [ ] **19. Google Sheets Product Queue**: Spreadsheet showing 52 products, statuses (`pending`, `published`), timestamps, and generated captions.
- [ ] **20. Workflow Execution Log**: Successful terminal or n8n execution output showing zero errors and generated Instagram caption with hashtags.
