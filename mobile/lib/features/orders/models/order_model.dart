import 'package:flutter/material.dart';
import '../../cart/models/cart_item_model.dart';
import '../../profile/models/address_model.dart';
import '../../../core/constants.dart';

enum OrderStatus {
  placed,
  confirmed,
  processing,
  dispatched,
  outForDelivery,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.dispatched:
        return 'Dispatched';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.placed:
        return AppColors.infoBlue;
      case OrderStatus.confirmed:
        return AppColors.accentTeal;
      case OrderStatus.processing:
        return AppColors.warningOrange;
      case OrderStatus.dispatched:
      case OrderStatus.outForDelivery:
        return Colors.purple;
      case OrderStatus.delivered:
        return AppColors.successGreen;
      case OrderStatus.cancelled:
        return AppColors.errorRed;
    }
  }

  static OrderStatus fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'processing':
        return OrderStatus.processing;
      case 'dispatched':
        return OrderStatus.dispatched;
      case 'out_for_delivery':
      case 'outfordelivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'placed':
      default:
        return OrderStatus.placed;
    }
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final bool isWholesale;
  final List<CartItemModel> items;
  final double subtotal;
  final double shippingFee;
  final double taxAmount;
  final double totalAmount;
  final AddressModel shippingAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String? paymentId;
  final OrderStatus orderStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.isWholesale,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.taxAmount,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paymentId,
    required this.orderStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'isWholesale': isWholesale,
      'items': items.map((i) => i.toMap()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress.toMap(),
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentId': paymentId,
      'orderStatus': orderStatus.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: docId ?? map['id'] ?? '',
      orderNumber: map['orderNumber'] ?? 'CAL-ORD-0000',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userPhone: map['userPhone'] ?? '',
      isWholesale: map['isWholesale'] ?? false,
      items: rawItems.map((item) => CartItemModel.fromMap(Map<String, dynamic>.from(item))).toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (map['shippingFee'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (map['taxAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shippingAddress: AddressModel.fromMap(Map<String, dynamic>.from(map['shippingAddress'] ?? {})),
      paymentMethod: map['paymentMethod'] ?? 'Razorpay Test',
      paymentStatus: map['paymentStatus'] ?? 'paid',
      paymentId: map['paymentId'],
      orderStatus: OrderStatus.fromString(map['orderStatus']),
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) ?? DateTime.now() : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now() : DateTime.now(),
    );
  }
}
