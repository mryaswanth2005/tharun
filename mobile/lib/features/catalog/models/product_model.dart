class ProductModel {
  final String id;
  final String sku;
  final String name;
  final String category;
  final String brand;
  final String description;
  final double price; // Customer retail price INR
  final double dealerPrice; // Lower wholesale dealer price INR
  final int stock;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic> specifications;
  final String imageUrl;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.brand,
    required this.description,
    required this.price,
    required this.dealerPrice,
    required this.stock,
    required this.rating,
    required this.reviewCount,
    required this.specifications,
    required this.imageUrl,
    this.isActive = true,
  });

  double effectivePrice(bool isApprovedDealer) {
    return isApprovedDealer ? dealerPrice : price;
  }

  double dealerSavings() {
    return price - dealerPrice;
  }

  int dealerSavingsPercentage() {
    if (price <= 0) return 0;
    return (((price - dealerPrice) / price) * 100).round();
  }

  bool get isInStock => stock > 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'category': category,
      'brand': brand,
      'description': description,
      'price': price,
      'dealerPrice': dealerPrice,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'specifications': specifications,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return ProductModel(
      id: docId ?? map['id'] ?? '',
      sku: map['sku'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'RO water purifiers',
      brand: map['brand'] ?? 'Califnco',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      dealerPrice: (map['dealerPrice'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      specifications: Map<String, dynamic>.from(map['specifications'] ?? {}),
      imageUrl: map['imageUrl'] ?? 'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=800&q=80',
      isActive: map['isActive'] ?? true,
    );
  }
}
