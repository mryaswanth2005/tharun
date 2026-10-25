import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class ProductRepository {
  List<ProductModel>? _cachedProducts;

  Future<List<ProductModel>> fetchProducts() async {
    if (_cachedProducts != null && _cachedProducts!.isNotEmpty) {
      return _cachedProducts!;
    }

    // Try fetching from Firestore first
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('isActive', isEqualTo: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _cachedProducts = snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
            .toList();
        return _cachedProducts!;
      }
    } catch (_) {
      // Fallback to local bundled seed data
    }

    // Load from local asset JSON
    try {
      final jsonString = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _cachedProducts = jsonList
          .map((item) => ProductModel.fromMap(Map<String, dynamic>.from(item), item['id']))
          .toList();
      return _cachedProducts!;
    } catch (e) {
      return [];
    }
  }

  Future<ProductModel?> fetchProductById(String id) async {
    final products = await fetchProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<ProductModel>> searchAndFilterProducts({
    String? category,
    String? query,
    String sortBy = 'featured',
  }) async {
    var list = await fetchProducts();

    // Category Filter
    if (category != null && category.isNotEmpty && category != 'All Products') {
      list = list.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    // Search Query
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      list = list.where((p) {
        final inName = p.name.toLowerCase().contains(q);
        final inBrand = p.brand.toLowerCase().contains(q);
        final inCategory = p.category.toLowerCase().contains(q);
        final inSku = p.sku.toLowerCase().contains(q);
        final inDesc = p.description.toLowerCase().contains(q);
        return inName || inBrand || inCategory || inSku || inDesc;
      }).toList();
    }

    // Sorting
    switch (sortBy) {
      case 'price_low_high':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high_low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popularity':
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'featured':
      default:
        break;
    }

    return list;
  }
}
