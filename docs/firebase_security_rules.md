# Firebase Security Rules & Authorization Strategy

The security model is defined in `backend/firestore.rules` and strictly enforced by Firebase servers.

## Security Highlights

1. **Role Separation**:
   - `Customer`: Can browse products, manage own cart, create orders, create service tickets, manage own addresses.
   - `Dealer`: Begins in `dealerStatus == 'pending'`. Only upon receiving `dealerStatus == 'approved'` from an Administrator can wholesale pricing orders be created.
   - `Admin`: Holds full read/write authority across orders, dealer applications, service bookings, inventory, and system settings.
2. **Privilege Escalation Prevention**:
   - Clients cannot write or update their own `role` or `dealerStatus`. Any attempt by a user to alter their role or dealer status in `/users/{userId}` is rejected at the Firestore rule level:
     ```javascript
     allow update: if isOwner(userId) && 
       (!request.resource.data.diff(resource.data).affectedKeys().hasAny(['role', 'dealerStatus'])) ||
       isAdmin();
     ```
3. **Wholesale Purchase Authorization Guard**:
   - An order marked `isWholesale: true` will be rejected by the rules engine unless the caller is verified as an approved dealer:
     ```javascript
     allow create: if isAuthenticated() && 
       request.resource.data.userId == request.auth.uid &&
       (!request.resource.data.isWholesale || isApprovedDealer());
     ```
4. **Order Status Tampering Prevention**:
   - Customers may only transition an order to `cancelled` if the current state is still `placed`. All other status transitions (Confirmed, Processing, Dispatched, Delivered) are restricted strictly to Administrators.
5. **Product & Catalog Immutability**:
   - The `/products/{productId}` collection is publicly readable so all visitors can browse the 52 products, but `create`, `update`, and `delete` operations require `isAdmin()`.

## Deploying Rules to Firebase
```bash
firebase deploy --only firestore:rules,firestore:indexes
```
