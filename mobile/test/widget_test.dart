import 'package:flutter_test/flutter_test.dart';
import 'package:califnco_app/features/catalog/models/product_model.dart';
import 'package:califnco_app/features/cart/models/cart_item_model.dart';
import 'package:califnco_app/features/cart/providers/cart_provider.dart';
import 'package:califnco_app/features/auth/models/user_model.dart';

void main() {
  group('ProductModel & Wholesale Pricing Tests', () {
    final samplePurifier = ProductModel(
      id: 'cal-ro-001',
      sku: 'CAL-RO-AQUAPRO',
      name: 'Califnco AquaPro RO 10L',
      category: 'RO water purifiers',
      brand: 'Califnco',
      description: 'Multi-stage RO purifier',
      price: 15000.0,
      dealerPrice: 10000.0,
      stock: 25,
      rating: 4.8,
      reviewCount: 150,
      specifications: {'Stages': '8 Stages', 'Capacity': '15 L/hr'},
      imageUrl: 'https://example.com/purifier.jpg',
    );

    test('Regular customer sees retail selling price', () {
      expect(samplePurifier.effectivePrice(false), 15000.0);
    });

    test('Approved dealer sees wholesale discount price', () {
      expect(samplePurifier.effectivePrice(true), 10000.0);
      expect(samplePurifier.dealerSavings(), 5000.0);
      expect(samplePurifier.dealerSavingsPercentage(), 33);
    });
  });

  group('Cart Calculations & Wholesale Threshold Tests', () {
    test('Calculates subtotal, 18% GST, and shipping correctly for retail customer', () {
      final item = CartItemModel(
        productId: 'cal-ro-001',
        sku: 'CAL-RO-AQUAPRO',
        name: 'Califnco AquaPro RO 10L',
        category: 'RO water purifiers',
        imageUrl: 'https://example.com/p.jpg',
        unitPrice: 15000.0,
        retailPrice: 15000.0,
        quantity: 1,
        stockLimit: 10,
        isWholesale: false,
      );

      final state = CartState(items: [item]);
      expect(state.subtotal, 15000.0);
      expect(state.gstTaxAmount, 2700.0); // 18% of 15,000
      expect(state.shippingFee, 0.0); // Free for > 999
      expect(state.grandTotal, 15000.0);
      expect(state.isWholesaleOrder, false);
      expect(state.meetsWholesaleMinimum(15000.0), true);
    });

    test('Enforces minimum ₹15,000 threshold for wholesale bulk orders', () {
      final wholesaleItemBelowMin = CartItemModel(
        productId: 'cal-sed-001',
        sku: 'CAL-SED-SPUN10',
        name: '10-inch Sediment Filter',
        category: 'Sediment filters',
        imageUrl: 'https://example.com/s.jpg',
        unitPrice: 240.0,
        retailPrice: 499.0,
        quantity: 10, // Total = 2,400
        stockLimit: 100,
        isWholesale: true,
      );

      final stateBelow = CartState(items: [wholesaleItemBelowMin]);
      expect(stateBelow.isWholesaleOrder, true);
      expect(stateBelow.meetsWholesaleMinimum(15000.0), false);

      final wholesaleItemAboveMin = wholesaleItemBelowMin.copyWith(quantity: 70); // Total = 16,800
      final stateAbove = CartState(items: [wholesaleItemAboveMin]);
      expect(stateAbove.meetsWholesaleMinimum(15000.0), true);
    });
  });

  group('UserModel Role & Security Tests', () {
    test('Correctly identifies approved vs pending vs customer', () {
      final customer = UserModel(
        uid: 'c1',
        email: 'customer@califnco.com',
        displayName: 'Customer User',
        role: UserRole.customer,
      );
      expect(customer.isApprovedDealer, false);
      expect(customer.isPendingDealer, false);
      expect(customer.isAdmin, false);

      final pendingDealer = UserModel(
        uid: 'd1',
        email: 'pending@dealer.com',
        displayName: 'Pending Dealer',
        role: UserRole.dealer,
        dealerStatus: DealerStatus.pending,
      );
      expect(pendingDealer.isApprovedDealer, false);
      expect(pendingDealer.isPendingDealer, true);

      final approvedDealer = UserModel(
        uid: 'd2',
        email: 'approved@dealer.com',
        displayName: 'Approved Dealer',
        role: UserRole.dealer,
        dealerStatus: DealerStatus.approved,
      );
      expect(approvedDealer.isApprovedDealer, true);
      expect(approvedDealer.isPendingDealer, false);
    });
  });
}
