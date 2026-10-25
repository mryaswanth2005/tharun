import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showRoleSwitcherSheet(BuildContext context, WidgetRef ref) {
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
                  'Switch roles instantly to test Customer vs Dealer wholesale pricing and Admin operations.',
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
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryNavy,
                    child: Text(
                      user != null && user.displayName.isNotEmpty
                          ? user.displayName.substring(0, 1).toUpperCase()
                          : 'C',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'Califnco User',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        StatusBadge(
                          label: user?.role.displayName ?? 'Customer',
                          color: user?.isApprovedDealer == true ? AppColors.accentTeal : AppColors.primaryNavy,
                          icon: user?.isApprovedDealer == true ? Icons.verified : Icons.person,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Demo Role Switcher Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.waterGlow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.accentAqua.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_horiz, color: AppColors.accentTeal),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Multi-Role Features',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryNavy),
                        ),
                        Text(
                          'Switch between Customer, Approved Dealer, and Admin',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showRoleSwitcherSheet(context, ref),
                    child: const Text('Switch Role', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Navigation Links
            _buildNavTile(
              icon: Icons.receipt_long_outlined,
              title: 'Orders & Purchase History',
              subtitle: 'Track live shipments and invoices',
              onTap: () => context.push('/orders'),
            ),
            const SizedBox(height: 8),
            _buildNavTile(
              icon: Icons.handyman_outlined,
              title: 'Service Bookings & AMC',
              subtitle: 'Installation, repairs, and filter replacement tickets',
              onTap: () => context.push('/services'),
            ),
            const SizedBox(height: 8),
            _buildNavTile(
              icon: Icons.location_on_outlined,
              title: 'Saved Delivery Addresses',
              subtitle: 'Manage home, office, and pinned GPS addresses',
              onTap: () => context.push('/saved-addresses'),
            ),
            const SizedBox(height: 8),
            _buildNavTile(
              icon: Icons.storefront_outlined,
              title: 'Wholesale & Dealer Hub',
              subtitle: 'Bulk purchasing and dealership verification status',
              onTap: () => context.push('/dealer-portal'),
            ),

            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.errorRed,
                  side: const BorderSide(color: AppColors.errorRed),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out / Reset Session'),
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Session reset. Ready for next evaluation test.')),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primaryNavy),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}
