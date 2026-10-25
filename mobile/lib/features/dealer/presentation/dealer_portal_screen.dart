import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../auth/providers/auth_provider.dart';

class DealerPortalScreen extends ConsumerWidget {
  const DealerPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isApproved = user?.isApprovedDealer ?? false;
    final isPending = user?.isPendingDealer ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Califnco Partner & Wholesale'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            if (isApproved) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF005F73), Color(0xFF0A9396)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'AUTHORIZED WHOLESALER',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StatusBadge(
                          label: 'ACTIVE PARTNER',
                          color: AppColors.successGreen,
                          icon: Icons.verified,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.companyName ?? user?.displayName ?? 'Califnco Partner',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'GSTIN: ${user?.gstNumber ?? "29ABCDE1234F1Z5"}',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.percent, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Wholesale Tier Unlocked: Save up to 35% on all 52 products & bulk spares.',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('Dealer Operations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),

              _buildActionTile(
                icon: Icons.inventory_2_outlined,
                title: 'Bulk Wholesale Catalog',
                subtitle: 'Order RO units, membranes, and pumps in bulk cartons',
                color: AppColors.primaryNavy,
                onTap: () => context.go('/catalog'),
              ),
              const SizedBox(height: 10),
              _buildActionTile(
                icon: Icons.history,
                title: 'Wholesale Purchase Orders',
                subtitle: 'View tax invoices and dispatched consignment tracking',
                color: AppColors.accentTeal,
                onTap: () => context.push('/orders'),
              ),
              const SizedBox(height: 10),
              _buildActionTile(
                icon: Icons.support_agent,
                title: 'Dedicated Wholesaler Desk',
                subtitle: 'Priority priority escalation: +91 98000 11223',
                color: AppColors.secondaryNavy,
                onTap: () {},
              ),
            ] else if (isPending) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.warningOrange, width: 1.5),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warningOrange.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.hourglass_top, color: AppColors.warningOrange, size: 36),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Application Under Review',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your dealership application for "${user?.companyName ?? "Your Company"}" has been received and is being verified against your GSTIN (${user?.gstNumber ?? "N/A"}).',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Estimated review time: Within 24 business hours.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Customer or New Applicant -> Apply for Dealership
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryNavy, AppColors.secondaryNavy],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Partner with Califnco',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Become an authorized dealer or service partner to unlock exclusive wholesale pricing, credit limits, and priority logistics.',
                      style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentAqua,
                        foregroundColor: AppColors.primaryNavy,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.assignment_ind),
                      label: const Text('Apply for Dealer Account', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () => context.push('/dealer-register'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('Dealer Benefits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _buildBenefitItem(Icons.trending_down, '25% - 40% Margin Discount', 'Substantial wholesale price advantages on purifiers and consumable spare packs.'),
              _buildBenefitItem(Icons.local_shipping, 'Direct Factory Consignments', 'Bulk pallets dispatched directly to your warehouse with GST invoices.'),
              _buildBenefitItem(Icons.verified, 'Authentic Spare Certification', '100% genuine membranes, NSF certified food grade tubing, and copper filters.'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.waterGlow.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.accentTeal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
