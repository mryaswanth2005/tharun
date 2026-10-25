import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants.dart';
import '../../../shared/widgets/status_badge.dart';
import '../models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt);

    return Scaffold(
      appBar: AppBar(title: Text(order.orderNumber)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Tracking Stepper
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Live Shipment Tracking',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      StatusBadge(label: order.orderStatus.label, color: order.orderStatus.color),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTrackingTimeline(order.orderStatus),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Items Purchased
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Items Ordered', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(height: 20),
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(color: AppColors.backgroundLight),
                                errorWidget: (context, url, error) => const Icon(Icons.water_drop, color: AppColors.accentTeal),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                Text('Qty: ${item.quantity} x ${AppConstants.currencyFormatter.format(item.unitPrice)}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Text(
                            AppConstants.currencyFormatter.format(item.totalPrice),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Delivery Address & Payment Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery & Payment Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(height: 20),
                  _buildDetailRow('Recipient', order.userName),
                  _buildDetailRow('Delivery Address', order.shippingAddress.fullAddress),
                  _buildDetailRow('Contact Phone', order.userPhone),
                  _buildDetailRow('Payment Mode', order.paymentMethod),
                  _buildDetailRow('Payment Status', order.paymentStatus.toUpperCase()),
                  if (order.paymentId != null) _buildDetailRow('Transaction ID', order.paymentId!),
                  _buildDetailRow('Order Placed On', dateStr),
                  const Divider(height: 20),
                  _buildDetailRow('Total Paid', AppConstants.currencyFormatter.format(order.totalAmount), isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Book Installation / Service CTA for this Order
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentTeal),
                icon: const Icon(Icons.handyman_outlined, size: 18),
                label: const Text('Book Installation / Technician for this Purifier'),
                onPressed: () {
                  context.push('/book-service', extra: order.items.first.name);
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(OrderStatus currentStatus) {
    final stages = [
      {'status': OrderStatus.placed, 'label': 'Placed'},
      {'status': OrderStatus.confirmed, 'label': 'Confirmed'},
      {'status': OrderStatus.processing, 'label': 'Packed'},
      {'status': OrderStatus.dispatched, 'label': 'Dispatched'},
      {'status': OrderStatus.delivered, 'label': 'Delivered'},
    ];

    final currentIndex = stages.indexWhere((s) => s['status'] == currentStatus);
    final activeStep = currentIndex >= 0 ? currentIndex : 0;

    return Row(
      children: List.generate(stages.length, (idx) {
        final isPassed = idx <= activeStep;
        final isLast = idx == stages.length - 1;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: isPassed ? AppColors.accentTeal : AppColors.surfaceBorder,
                    child: Icon(
                      isPassed ? Icons.check : Icons.circle,
                      size: 12,
                      color: isPassed ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stages[idx]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isPassed ? FontWeight.bold : FontWeight.normal,
                      color: isPassed ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: idx < activeStep ? AppColors.accentTeal : AppColors.surfaceBorder,
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
