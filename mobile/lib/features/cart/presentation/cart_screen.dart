import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    if (cartState.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Cart')),
        body: EmptyStateWidget(
          icon: Icons.shopping_cart_outlined,
          title: 'Your Cart is Empty',
          description: 'Looks like you have not added any water purifiers or filtration spares yet.',
          buttonText: 'Browse Catalog',
          onButtonPressed: () => context.go('/catalog'),
        ),
      );
    }

    final meetsWholesaleMin = !cartState.isWholesaleOrder ||
        cartState.meetsWholesaleMinimum(AppConstants.minWholesaleOrderAmount);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cartState.isWholesaleOrder ? 'Wholesale Bulk Cart' : 'Shopping Cart (${cartState.totalItemCount})',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Cart',
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Wholesale Banner / Warning
          if (cartState.isWholesaleOrder) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: meetsWholesaleMin
                  ? AppColors.accentTeal.withOpacity(0.12)
                  : AppColors.warningOrange.withOpacity(0.12),
              child: Row(
                children: [
                  Icon(
                    meetsWholesaleMin ? Icons.check_circle : Icons.warning_amber_rounded,
                    color: meetsWholesaleMin ? AppColors.accentTeal : AppColors.warningOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      meetsWholesaleMin
                          ? 'Wholesale Tier Applied! Total Dealer Savings: ${AppConstants.currencyFormatter.format(cartState.totalSavings)}'
                          : 'Minimum wholesale order is ${AppConstants.currencyFormatter.format(AppConstants.minWholesaleOrderAmount)}. Please add more items.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: meetsWholesaleMin ? AppColors.accentTeal : Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Items List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartState.items.length,
              separatorBuilder: (context, idx) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final item = cartState.items[idx];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: AppColors.backgroundLight),
                            errorWidget: (context, url, error) => const Icon(Icons.water_drop, color: AppColors.accentTeal),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Item Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SKU: ${item.sku}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  AppConstants.currencyFormatter.format(item.unitPrice),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: item.isWholesale ? AppColors.accentTeal : AppColors.primaryNavy,
                                  ),
                                ),
                                if (item.isWholesale) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    AppConstants.currencyFormatter.format(item.retailPrice),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Quantity Selector & Delete
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              ref.read(cartProvider.notifier).removeItem(item.productId);
                            },
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.surfaceBorder),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    ref.read(cartProvider.notifier).updateQuantity(item.productId, item.quantity - 1);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.remove, size: 14),
                                  ),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () {
                                    ref.read(cartProvider.notifier).updateQuantity(item.productId, item.quantity + 1);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.add, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Order Summary & Checkout Action
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: AppColors.surfaceBorder)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text(
                        AppConstants.currencyFormatter.format(cartState.subtotal),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GST (18% Included)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text(
                        AppConstants.currencyFormatter.format(cartState.gstTaxAmount),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Express Shipping', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text(
                        cartState.shippingFee == 0 ? 'FREE' : AppConstants.currencyFormatter.format(cartState.shippingFee),
                        style: const TextStyle(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Payable',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        AppConstants.currencyFormatter.format(cartState.grandTotal),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: meetsWholesaleMin ? AppColors.primaryNavy : Colors.grey,
                      ),
                      onPressed: meetsWholesaleMin
                          ? () {
                              context.push('/checkout');
                            }
                          : null,
                      child: Text(
                        meetsWholesaleMin
                            ? 'Proceed to Checkout (${cartState.totalItemCount} items)'
                            : 'Min Wholesale ₹15,000 Required',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
