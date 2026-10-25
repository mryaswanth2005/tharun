import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchProducts();
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'All Products');
final searchQueryProvider = StateProvider<String>((ref) => '');
final sortByProvider = StateProvider<String>((ref) => 'featured');

final filteredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final allProductsAsync = ref.watch(allProductsProvider);
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider);
  final sort = ref.watch(sortByProvider);

  return allProductsAsync.whenData((products) {
    var list = List<ProductModel>.from(products);

    if (category != 'All Products') {
      list = list.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    }

    switch (sort) {
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
    }

    return list;
  });
});

final productDetailsProvider = FutureProvider.family<ProductModel?, String>((ref, id) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchProductById(id);
});
