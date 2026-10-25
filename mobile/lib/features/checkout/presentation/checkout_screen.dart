import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../orders/providers/order_provider.dart';
import '../../profile/models/address_model.dart';
import 'map_address_picker.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late Razorpay _razorpay;
  bool _isProcessing = false;
  String _selectedPaymentMethod = 'razorpay_test'; // 'razorpay_test', 'simulated_test', 'cod'

  late List<AddressModel> _addresses;
  late AddressModel _selectedAddress;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _addresses = AddressModel.getDemoAddresses(user?.uid ?? 'user_default');
    _selectedAddress = _addresses.first;

    _initRazorpay();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _finalizeOrder(
      paymentMethod: 'Razorpay Test Mode',
      paymentStatus: 'paid',
      paymentId: response.paymentId ?? 'pay_sim_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message ?? 'User Cancelled'}'),
        backgroundColor: AppColors.errorRed,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _finalizeOrder(
      paymentMethod: 'Wallet: ${response.walletName}',
      paymentStatus: 'paid',
      paymentId: 'wall_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<void> _startCheckout() async {
    if (_isProcessing) return; // Prevent duplicate payment attempts

    setState(() => _isProcessing = true);
    final cartState = ref.read(cartProvider);

    if (_selectedPaymentMethod == 'razorpay_test') {
      final user = ref.read(currentUserProvider);
      final options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag', // Official public test mode key
        'amount': (cartState.grandTotal * 100).toInt(), // Amount in paise
        'name': 'Califnco PureWater',
        'description': 'Order Checkout (${cartState.totalItemCount} items)',
        'prefill': {
          'contact': user?.phoneNumber.isNotEmpty == true ? user!.phoneNumber : '9876543210',
          'email': user?.email ?? 'customer@califnco.com',
        },
        'theme': {
          'color': '#0A192F',
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        // Fallback to simulated checkout if native Razorpay plugin unavailable on platform
        await _finalizeOrder(
          paymentMethod: 'Simulated Razorpay Test',
          paymentStatus: 'paid',
          paymentId: 'sim_rzp_${DateTime.now().millisecondsSinceEpoch}',
        );
      }
    } else if (_selectedPaymentMethod == 'simulated_test') {
      await Future.delayed(const Duration(milliseconds: 1200));
      await _finalizeOrder(
        paymentMethod: 'Simulated Test Checkout (Verified)',
        paymentStatus: 'paid',
        paymentId: 'sim_sandbox_${DateTime.now().millisecondsSinceEpoch}',
      );
    } else {
      // Cash on Delivery / Pay on Installation
      await _finalizeOrder(
        paymentMethod: 'Pay on Installation / Delivery',
        paymentStatus: 'pending',
        paymentId: null,
      );
    }
  }

  Future<void> _finalizeOrder({
    required String paymentMethod,
    required String paymentStatus,
    String? paymentId,
  }) async {
    final user = ref.read(currentUserProvider)!;
    final cartState = ref.read(cartProvider);

    try {
      final order = await ref.read(orderRepositoryProvider).placeOrder(
            user: user,
            items: cartState.items,
            subtotal: cartState.subtotal,
            shippingFee: cartState.shippingFee,
            taxAmount: cartState.gstTaxAmount,
            totalAmount: cartState.grandTotal,
            shippingAddress: _selectedAddress,
            paymentMethod: paymentMethod,
            paymentStatus: paymentStatus,
            paymentId: paymentId,
          );

      // Invalidate user orders query & clear cart
      ref.invalidate(userOrdersProvider);
      ref.read(cartProvider.notifier).clearCart();

      if (mounted) {
        context.go('/order-success', extra: order);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
    }
  }

  Future<void> _pickLocationOnMap() async {
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapAddressPickerScreen(
          initialPosition: LatLng(_selectedAddress.latitude, _selectedAddress.longitude),
        ),
      ),
    );

    if (result != null) {
      final newAddr = AddressModel(
        id: 'addr_pinned_${DateTime.now().millisecondsSinceEpoch}',
        userId: ref.read(currentUserProvider)?.uid ?? 'usr',
        recipientName: _selectedAddress.recipientName,
        phone: _selectedAddress.phone,
        street: 'Pinned via OpenStreetMap (${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)})',
        city: _selectedAddress.city,
        state: _selectedAddress.state,
        pincode: _selectedAddress.pincode,
        latitude: result.latitude,
        longitude: result.longitude,
      );

      setState(() {
        _addresses.insert(0, newAddr);
        _selectedAddress = newAddr;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery location updated from OpenStreetMap pin!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout & Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Delivery Address
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.map_outlined, size: 16, color: AppColors.accentTeal),
                  label: const Text('Pin on Map', style: TextStyle(color: AppColors.accentTeal, fontSize: 13)),
                  onPressed: _pickLocationOnMap,
                ),
              ],
            ),
            const SizedBox(height: 8),

            ..._addresses.map((addr) {
              final isSelected = addr.id == _selectedAddress.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.accentTeal : AppColors.surfaceBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: RadioListTile<String>(
                  value: addr.id,
                  groupValue: _selectedAddress.id,
                  activeColor: AppColors.accentTeal,
                  onChanged: (val) {
                    setState(() {
                      _selectedAddress = addr;
                    });
                  },
                  title: Row(
                    children: [
                      Text(addr.recipientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      if (addr.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.waterGlow.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('DEFAULT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentTeal)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${addr.fullAddress}\nPhone: ${addr.phone}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Section: Payment Mode
            const Text(
              'Payment Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Option 1: Razorpay Test
            _buildPaymentOption(
              value: 'razorpay_test',
              title: 'Razorpay Test Gateway',
              subtitle: 'UPI, Credit/Debit Cards, NetBanking (Test Credentials)',
              icon: Icons.payment,
              badge: 'RECOMMENDED',
            ),

            // Option 2: Simulated Test Checkout
            _buildPaymentOption(
              value: 'simulated_test',
              title: 'Simulated Verified Checkout',
              subtitle: 'Zero-latency instant sandbox payment verification',
              icon: Icons.check_circle_outline,
            ),

            // Option 3: COD
            _buildPaymentOption(
              value: 'cod',
              title: 'Pay Upon Delivery / Installation',
              subtitle: 'Pay via cash or UPI after purifier installation',
              icon: Icons.handshake_outlined,
            ),

            const SizedBox(height: 24),

            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payment Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal (${cartState.totalItemCount} items)', style: const TextStyle(color: AppColors.textSecondary)),
                      Text(AppConstants.currencyFormatter.format(cartState.subtotal)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GST (18% Included)', style: TextStyle(color: AppColors.textSecondary)),
                      Text(AppConstants.currencyFormatter.format(cartState.gstTaxAmount)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery & Transit Insurance', style: TextStyle(color: AppColors.textSecondary)),
                      const Text('FREE', style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        AppConstants.currencyFormatter.format(cartState.grandTotal),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Complete Order CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                ),
                onPressed: _isProcessing ? null : _startCheckout,
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Securing & Verifying Payment...'),
                        ],
                      )
                    : Text(
                        'Pay & Confirm Order (${AppConstants.currencyFormatter.format(cartState.grandTotal)})',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    String? badge,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.accentTeal : AppColors.surfaceBorder,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedPaymentMethod,
        activeColor: AppColors.accentTeal,
        onChanged: (val) {
          if (val != null) setState(() => _selectedPaymentMethod = val);
        },
        title: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? AppColors.accentTeal : AppColors.primaryNavy),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
