# Firestore Schema Documentation

This document describes all Cloud Firestore collections, documents, subcollections, and data structures utilized by Califnco.

---

## 1. `users` Collection
**Path:** `/users/{userId}`

| Field | Type | Description |
| :--- | :--- | :--- |
| `uid` | string | Firebase Auth UID or system generated ID |
| `email` | string | User email address |
| `displayName` | string | Full name or authorized contact |
| `phoneNumber` | string | Contact phone with country code |
| `role` | string | `'customer'` \| `'dealer'` \| `'admin'` |
| `dealerStatus` | string \| null | `'pending'` \| `'approved'` \| `'rejected'` (if role == 'dealer') |
| `companyName` | string \| null | Business name (dealers only) |
| `gstNumber` | string \| null | 15-character GSTIN tax identification |
| `businessAddress`| string \| null | Registered office / warehouse address |
| `createdAt` | timestamp | Timestamp of registration |

---

## 2. `products` Collection
**Path:** `/products/{productId}`

| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | string | Unique product slug (e.g., `cal-ro-001`) |
| `sku` | string | Unique SKU (e.g., `CAL-RO-AQUAPRO`) |
| `name` | string | Official product title |
| `category` | string | One of the 10 catalog categories |
| `brand` | string | `Califnco` \| `Califnco Pro` \| `Califnco AquaTech` |
| `description` | string | Technical description |
| `price` | number | Customer retail price in INR |
| `dealerPrice` | number | Lower wholesale dealer price in INR |
| `stock` | number | Real-time available inventory quantity |
| `rating` | number | Average rating (1.0 to 5.0) |
| `reviewCount` | number | Total number of customer reviews |
| `specifications` | map | Key-value pairs of technical parameters |
| `imageUrl` | string | High resolution public image URL |
| `isActive` | boolean | Catalog visibility flag |
| `createdAt` | timestamp | Creation timestamp |

---

## 3. `orders` Collection
**Path:** `/orders/{orderId}`

| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | string | Document ID |
| `orderNumber` | string | Display code (e.g., `CAL-ORD-9412` or `CAL-WHL-8821`) |
| `userId` | string | Buyer UID |
| `userName` | string | Recipient name |
| `userEmail` | string | Recipient email |
| `userPhone` | string | Contact phone |
| `isWholesale` | boolean | True if purchased under authorized dealer tier |
| `items` | array[map] | Array of item maps with quantities and prices |
| `subtotal` | number | Subtotal in INR |
| `shippingFee` | number | Shipping charge (0 for free) |
| `taxAmount` | number | 18% GST component in INR |
| `totalAmount` | number | Grand total payable in INR |
| `shippingAddress`| map | Street, landmark, city, state, pincode, lat, lng |
| `paymentMethod` | string | `'Razorpay Test'` \| `'Simulated Test'` \| `'COD'` |
| `paymentStatus` | string | `'paid'` \| `'pending'` \| `'failed'` |
| `paymentId` | string \| null | Razorpay or transaction reference ID |
| `orderStatus` | string | `'placed'` \| `'confirmed'` \| `'processing'` \| `'dispatched'` \| `'delivered'` \| `'cancelled'` |
| `createdAt` | timestamp | Placement timestamp |
| `updatedAt` | timestamp | Last status change timestamp |

---

## 4. `dealerApplications` Collection
**Path:** `/dealerApplications/{applicationId}`

| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | string | Application ID (matches userId) |
| `userId` | string | Applicant UID |
| `contactName` | string | Representative name |
| `email` | string | Business email |
| `phone` | string | Mobile phone |
| `companyName` | string | Registered company name |
| `gstNumber` | string | 15-character GSTIN |
| `address` | string | Business premises address |
| `status` | string | `'pending'` \| `'approved'` \| `'rejected'` |
| `adminDecisionNotes`| string \| null | Compliance rationale recorded by Admin |
| `reviewedBy` | string \| null | Admin username |
| `reviewedAt` | timestamp \| null | Timestamp of decision |
| `createdAt` | timestamp | Submission timestamp |

---

## 5. `serviceBookings` Collection
**Path:** `/serviceBookings/{bookingId}`

| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | string | Ticket ID |
| `ticketNumber` | string | Display code (e.g., `CAL-SRV-1042`) |
| `userId` | string | Customer UID |
| `customerName` | string | Customer name |
| `customerPhone` | string | Contact phone |
| `address` | map | Complete delivery address map |
| `serviceType` | string | Service category |
| `purifierModel` | string | Appliance model name |
| `preferredDate` | string | Requested service date |
| `preferredTimeSlot` | string | Time window |
| `status` | string | `'pending'` \| `'assigned'` \| `'inProgress'` \| `'completed'` \| `'cancelled'` |
| `assignedTechnician`| string \| null | Technician name, phone, and zone |
| `notes` | string | Customer instructions or symptoms |
| `createdAt` | timestamp | Booking timestamp |
| `updatedAt` | timestamp | Status update timestamp |

---

## 6. `appSettings` Collection
**Path:** `/appSettings/global`

| Field | Type | Description |
| :--- | :--- | :--- |
| `taxRatePercentage` | number | Default 18 (%) |
| `standardShippingFee` | number | Default 0 (Free shipping) |
| `minWholesaleOrderAmount` | number | ₹15,000 INR |
| `supportPhone` | string | Customer helpline |
| `supportEmail` | string | Support inbox |
