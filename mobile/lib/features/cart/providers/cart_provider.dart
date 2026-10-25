import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../catalog/models/product_model.dart';
import '../models/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get totalSavings => items.fold(0.0, (sum, item) => sum + item.totalSavings);
  
  // 18% GST included in price or added transparently
  double get gstTaxAmount => subtotal * 0.18;
  
  // Free shipping above ₹999 or for all orders
  double get shippingFee => (subtotal > 999 || subtotal == 0) ? 0.0 : 99.0;
  
  double get grandTotal => subtotal + shippingFee;

  bool get isWholesaleOrder => items.any((item) => item.isWholesale);

  bool meetsWholesaleMinimum(double minAmount) {
    if (!isWholesaleOrder) return true;
    return subtotal >= minAmount;
  }

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(ProductModel product, {required bool isApprovedDealer, int quantity = 1}) {
    final existingIndex = state.items.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      final currentItem = state.items[existingIndex];
      final newQty = (currentItem.quantity + quantity).clamp(1, product.stock);
      final updatedList = List<CartItemModel>.from(state.items);
      updatedList[existingIndex] = currentItem.copyWith(quantity: newQty);
      state = state.copyWith(items: updatedList);
    } else {
      final newItem = CartItemModel.fromProduct(
        product,
        isApprovedDealer: isApprovedDealer,
        quantity: quantity.clamp(1, product.stock),
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedList = state.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: newQuantity.clamp(1, item.stockLimit));
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedList);
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.productId != productId).toList(),
    );
  }

  void clearCart() {
    state = const CartState(items: []);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
