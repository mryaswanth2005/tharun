import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../../checkout/presentation/map_address_picker.dart';
import '../models/address_model.dart';

class SavedAddressesScreen extends ConsumerStatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  ConsumerState<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends ConsumerState<SavedAddressesScreen> {
  late List<AddressModel> _addresses;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _addresses = AddressModel.getDemoAddresses(user?.uid ?? 'usr');
  }

  Future<void> _pinNewAddressOnMap() async {
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapAddressPickerScreen(),
      ),
    );

    if (result != null) {
      final newAddr = AddressModel(
        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
        userId: ref.read(currentUserProvider)?.uid ?? 'usr',
        recipientName: ref.read(currentUserProvider)?.displayName ?? 'My Place',
        phone: ref.read(currentUserProvider)?.phoneNumber ?? '+91 98765 12345',
        street: 'Pinned via OpenStreetMap (${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)})',
        city: 'Bengaluru',
        state: 'Karnataka',
        pincode: '560103',
        latitude: result.latitude,
        longitude: result.longitude,
      );

      setState(() {
        _addresses.insert(0, newAddr);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New delivery location saved from map pin!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Delivery Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryNavy,
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text('Pin New Address on Map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: _pinNewAddressOnMap,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: _addresses.length,
        separatorBuilder: (context, idx) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final addr = _addresses[idx];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(addr.recipientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    if (addr.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.waterGlow.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('DEFAULT', style: TextStyle(color: AppColors.accentTeal, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  addr.fullAddress,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(addr.phone, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    const Spacer(),
                    Text(
                      'GPS: ${addr.latitude.toStringAsFixed(2)}, ${addr.longitude.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 11, color: AppColors.accentTeal),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
