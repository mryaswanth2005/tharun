import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/models/address_model.dart';
import '../providers/service_provider.dart';

class BookServiceScreen extends ConsumerStatefulWidget {
  final String? initialPurifierModel;

  const BookServiceScreen({super.key, this.initialPurifierModel});

  @override
  ConsumerState<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends ConsumerState<BookServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedServiceType;
  late final TextEditingController _modelController;
  late final TextEditingController _notesController;
  late DateTime _selectedDate;
  String _selectedSlot = '10:00 AM - 01:00 PM';
  bool _isSubmitting = false;

  late List<AddressModel> _addresses;
  late AddressModel _selectedAddress;

  final List<String> _timeSlots = [
    '09:00 AM - 12:00 PM (Morning)',
    '12:00 PM - 03:00 PM (Afternoon)',
    '03:00 PM - 06:00 PM (Evening)',
    '06:00 PM - 08:00 PM (Late Slot)',
  ];

  @override
  void initState() {
    super.initState();
    _selectedServiceType = AppConstants.serviceTypes.first;
    _modelController = TextEditingController(text: widget.initialPurifierModel ?? 'Califnco AquaPro RO 10L');
    _notesController = TextEditingController();
    _selectedDate = DateTime.now().add(const Duration(days: 1));

    final user = ref.read(currentUserProvider);
    _addresses = AddressModel.getDemoAddresses(user?.uid ?? 'usr');
    _selectedAddress = _addresses.first;
  }

  @override
  void dispose() {
    _modelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final user = ref.read(currentUserProvider)!;

    try {
      final formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);

      await ref.read(serviceRepositoryProvider).bookTicket(
            userId: user.uid,
            customerName: user.displayName,
            customerPhone: user.phoneNumber.isNotEmpty ? user.phoneNumber : _selectedAddress.phone,
            address: _selectedAddress,
            serviceType: _selectedServiceType,
            purifierModel: _modelController.text.trim(),
            preferredDate: formattedDate,
            preferredTimeSlot: _selectedSlot,
            notes: _notesController.text.trim(),
          );

      ref.invalidate(userServiceBookingsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service Request Booked! A technician will be assigned shortly.'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book service: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Service / AMC')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Type Dropdown
              const Text('Service Required', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedServiceType,
                    isExpanded: true,
                    items: AppConstants.serviceTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontSize: 14)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedServiceType = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Purifier Model
              const Text('Purifier Model / Appliance Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Califnco AquaPro 10L, Kent, Aquaguard...',
                  prefixIcon: Icon(Icons.water_drop, color: AppColors.accentTeal),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please specify your purifier model' : null,
              ),

              const SizedBox(height: 18),

              // Preferred Date Picker
              const Text('Preferred Service Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: AppColors.accentTeal),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('EEE, dd MMM yyyy').format(_selectedDate),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Text('Change', style: TextStyle(color: AppColors.accentTeal, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Preferred Time Slot
              const Text('Preferred Time Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSlot,
                    isExpanded: true,
                    items: _timeSlots.map((slot) {
                      return DropdownMenuItem(value: slot, child: Text(slot, style: const TextStyle(fontSize: 14)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSlot = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Service Address
              const Text('Service Location Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              ..._addresses.map((addr) {
                final isSelected = addr.id == _selectedAddress.id;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
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
                    onChanged: (val) => setState(() => _selectedAddress = addr),
                    title: Text(addr.recipientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(addr.fullAddress, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ),
                );
              }),

              const SizedBox(height: 18),

              // Problem Description / Notes
              const Text('Issue Description / Instructions (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Low water flow, membrane change due, beeping alert, foul taste...',
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                  onPressed: _isSubmitting ? null : _submitBooking,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text('Confirm Service Booking', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
