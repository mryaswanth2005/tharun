import '../../catalog/models/product_model.dart';

class CartItemModel {
  final String productId;
  final String sku;
  final String name;
  final String category;
  final String imageUrl;
  final double unitPrice; // Bound to customer or dealer wholesale price
  final double retailPrice; // Original retail price for displaying dealer savings
  final int quantity;
  final int stockLimit;
  final bool isWholesale;

  CartItemModel({
    required this.productId,
    required this.sku,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.unitPrice,
    required this.retailPrice,
    required this.quantity,
    required this.stockLimit,
    this.isWholesale = false,
  });

  double get totalPrice => unitPrice * quantity;
  double get totalSavings => (retailPrice - unitPrice) * quantity;

  CartItemModel copyWith({
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId,
      sku: sku,
      name: name,
      category: category,
      imageUrl: imageUrl,
      unitPrice: unitPrice,
      retailPrice: retailPrice,
      quantity: quantity ?? this.quantity,
      stockLimit: stockLimit,
      isWholesale: isWholesale,
    );
  }

  factory CartItemModel.fromProduct(ProductModel product, {required bool isApprovedDealer, int quantity = 1}) {
    final effective = product.effectivePrice(isApprovedDealer);
    return CartItemModel(
      productId: product.id,
      sku: product.sku,
      name: product.name,
      category: product.category,
      imageUrl: product.imageUrl,
      unitPrice: effective,
      retailPrice: product.price,
      quantity: quantity,
      stockLimit: product.stock,
      isWholesale: isApprovedDealer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'sku': sku,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'unitPrice': unitPrice,
      'retailPrice': retailPrice,
      'quantity': quantity,
      'stockLimit': stockLimit,
      'isWholesale': isWholesale,
      'totalPrice': totalPrice,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] ?? '',
      sku: map['sku'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      retailPrice: (map['retailPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      stockLimit: (map['stockLimit'] as num?)?.toInt() ?? 100,
      isWholesale: map['isWholesale'] ?? false,
    );
  }
}
