import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/product_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/catalog_provider.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showRoleSwitcherSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Switch Demo User Role',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Switch roles instantly to test Customer vs Dealer wholesale pricing and Admin features.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.infoBlue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: const Text('Customer (Rahul Sharma)'),
                  subtitle: const Text('Standard retail pricing with 18% GST'),
                  onTap: () {
                    ref.read(authProvider.notifier).switchDemoRole('customer@califnco.com');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.accentTeal,
                    child: Icon(Icons.verified, color: Colors.white),
                  ),
                  title: const Text('Approved Wholesale Partner (Apex Water)'),
                  subtitle: const Text('Unlocks discounted wholesale dealer prices on all 52 products'),
                  onTap: () {
                    ref.read(authProvider.notifier).switchDemoRole('dealer.approved@califnco.com');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.warningOrange,
                    child: Icon(Icons.hourglass_top, color: Colors.white),
                  ),
                  title: const Text('Pending Dealer (Krishna Enterprises)'),
                  subtitle: const Text('Application under review; retail prices shown'),
                  onTap: () {
                    ref.read(authProvider.notifier).switchDemoRole('dealer.pending@califnco.com');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryNavy,
                    child: Icon(Icons.admin_panel_settings, color: Colors.white),
                  ),
                  title: const Text('Califnco Admin Ops'),
                  subtitle: const Text('Full administrative access'),
                  onTap: () {
                    ref.read(authProvider.notifier).switchDemoRole('admin@califnco.com');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isApprovedDealer = ref.watch(isApprovedDealerProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productsAsync = ref.watch(filteredProductsProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryNavy,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.water_drop, color: AppColors.accentAqua, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Califnco PureWater',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  isApprovedDealer ? 'Wholesale Partner Portal' : 'Pure Drinking Water Systems',
                  style: const TextStyle(fontSize: 11, color: AppColors.accentTeal, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Demo Role Switcher Chip
          ActionChip(
            avatar: Icon(
              isApprovedDealer ? Icons.verified : Icons.account_circle,
              size: 16,
              color: isApprovedDealer ? AppColors.accentTeal : AppColors.primaryNavy,
            ),
            label: Text(
              currentUser?.role.displayName ?? 'Role',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _showRoleSwitcherSheet(context),
          ),
          const SizedBox(width: 8),
          // Cart Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => context.push('/cart'),
              ),
              if (cartState.totalItemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accentTeal,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${cartState.totalItemCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Dealer Banner
          if (isApprovedDealer)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.accentTeal.withOpacity(0.12),
              child: Row(
                children: [
                  const Icon(Icons.discount, color: AppColors.accentTeal, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Wholesale Pricing Active: Up to 35% discount applied across all 52 products.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search RO, UV, membranes, pumps, filters...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).state = val;
              },
            ),
          ),

          // Category Chips Horizontal Scroll
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: AppConstants.categories.length,
              itemBuilder: (context, idx) {
                final category = AppConstants.categories[idx];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    label: Text(category),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primaryNavy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryNavy : AppColors.surfaceBorder,
                      ),
                    ),
                    onSelected: (selected) {
                      ref.read(selectedCategoryProvider.notifier).state = category;
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Product Grid
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accentTeal),
              ),
              error: (err, st) => Center(
                child: Text('Error loading catalog: $err'),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.search_off,
                    title: 'No Products Found',
                    description: 'Try adjusting your search query or selecting a different category.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                      ref.read(selectedCategoryProvider.notifier).state = 'All Products';
                    },
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, idx) {
                    final product = products[idx];
                    return ProductCard(
                      product: product,
                      isApprovedDealer: isApprovedDealer,
                      onTap: () {
                        context.push('/product/${product.id}');
                      },
                      onAddToCart: () {
                        ref.read(cartProvider.notifier).addItem(
                              product,
                              isApprovedDealer: isApprovedDealer,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added "${product.name}" to cart'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              textColor: AppColors.accentAqua,
                              onPressed: () => context.push('/cart'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
