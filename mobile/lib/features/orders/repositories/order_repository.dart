import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../../cart/models/cart_item_model.dart';
import '../../profile/models/address_model.dart';
import '../../auth/models/user_model.dart';

class OrderRepository {
  static const String _localOrdersKey = 'califnco_orders_cache';
  final List<OrderModel> _inMemoryOrders = [];

  OrderRepository() {
    _loadInitialCache();
  }

  Future<void> _loadInitialCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_localOrdersKey);
      if (list != null && list.isNotEmpty) {
        _inMemoryOrders.clear();
        for (final item in list) {
          final map = jsonDecode(item);
          _inMemoryOrders.add(OrderModel.fromMap(map, map['id']));
        }
      }
    } catch (_) {}
  }

  Future<void> _persistLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _inMemoryOrders.map((o) => jsonEncode(o.toMap())).toList();
      await prefs.setStringList(_localOrdersKey, list);
    } catch (_) {}
  }

  Future<OrderModel> placeOrder({
    required UserModel user,
    required List<CartItemModel> items,
    required double subtotal,
    required double shippingFee,
    required double taxAmount,
    required double totalAmount,
    required AddressModel shippingAddress,
    required String paymentMethod,
    required String paymentStatus,
    String? paymentId,
  }) async {
    final orderId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
    final randomSuffix = (1000 + (DateTime.now().microsecond % 9000));
    final orderNumber = 'CAL-${user.isApprovedDealer ? 'WHL' : 'ORD'}-$randomSuffix';

    final order = OrderModel(
      id: orderId,
      orderNumber: orderNumber,
      userId: user.uid,
      userName: user.displayName,
      userEmail: user.email,
      userPhone: user.phoneNumber.isNotEmpty ? user.phoneNumber : shippingAddress.phone,
      isWholesale: user.isApprovedDealer,
      items: items,
      subtotal: subtotal,
      shippingFee: shippingFee,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      paymentId: paymentId,
      orderStatus: OrderStatus.placed,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save to Firestore if connected
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(order.toMap());
    } catch (_) {}

    _inMemoryOrders.insert(0, order);
    await _persistLocal();
    return order;
  }

  Future<List<OrderModel>> fetchUserOrders(String userId) async {
    await _loadInitialCache();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList();
      }
    } catch (_) {}

    return _inMemoryOrders.where((o) => o.userId == userId || userId == 'demo_customer_01').toList();
  }

  Future<List<OrderModel>> fetchAllOrders() async {
    await _loadInitialCache();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList();
      }
    } catch (_) {}

    return List.from(_inMemoryOrders);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'orderStatus': newStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}

    final idx = _inMemoryOrders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      final existing = _inMemoryOrders[idx];
      _inMemoryOrders[idx] = OrderModel(
        id: existing.id,
        orderNumber: existing.orderNumber,
        userId: existing.userId,
        userName: existing.userName,
        userEmail: existing.userEmail,
        userPhone: existing.userPhone,
        isWholesale: existing.isWholesale,
        items: existing.items,
        subtotal: existing.subtotal,
        shippingFee: existing.shippingFee,
        taxAmount: existing.taxAmount,
        totalAmount: existing.totalAmount,
        shippingAddress: existing.shippingAddress,
        paymentMethod: existing.paymentMethod,
        paymentStatus: existing.paymentStatus,
        paymentId: existing.paymentId,
        orderStatus: newStatus,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );
      await _persistLocal();
    }
  }
}
