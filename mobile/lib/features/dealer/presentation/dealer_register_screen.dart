import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../auth/providers/auth_provider.dart';

class DealerRegisterScreen extends ConsumerStatefulWidget {
  const DealerRegisterScreen({super.key});

  @override
  ConsumerState<DealerRegisterScreen> createState() => _DealerRegisterScreenState();
}

class _DealerRegisterScreenState extends ConsumerState<DealerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _contactNameCtrl = TextEditingController();
  final _companyNameCtrl = TextEditingController();
  final _gstCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController(text: 'DealerPass@123');
  final _addressCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contactNameCtrl.dispose();
    _companyNameCtrl.dispose();
    _gstCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(authProvider.notifier).registerDealer(
            contactName: _contactNameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            companyName: _companyNameCtrl.text.trim(),
            gstNumber: _gstCtrl.text.trim().toUpperCase(),
            address: _addressCtrl.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dealer Application Submitted! Status: Under Admin Review.'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Dealer Partnership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wholesale Partner Application',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
              const SizedBox(height: 6),
              const Text(
                'Please provide valid business credentials to obtain wholesale purchasing authorization.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Contact Name
              const Text('Authorized Representative Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contactNameCtrl,
                decoration: const InputDecoration(hintText: 'e.g. Ramesh Chandra'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              // Company Name
              const Text('Registered Business / Firm Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _companyNameCtrl,
                decoration: const InputDecoration(hintText: 'e.g. Chandra Water Solutions Pvt Ltd'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              // GSTIN
              const Text('GSTIN (15-digit Tax Identification)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _gstCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(hintText: 'e.g. 29AAAAA0000A1Z5'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'GSTIN is required for wholesale status';
                  if (val.trim().length != 15) return 'GSTIN must be exactly 15 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone & Email
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mobile Phone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(hintText: '+91 98765 00000'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Business Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: 'dealer@domain.com'),
                          validator: (val) => val == null || !val.contains('@') ? 'Valid email required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Business Address
              const Text('Warehouse / Registered Office Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _addressCtrl,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Shop / Warehouse No, Street, City, State, Pincode'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Address required' : null,
              ),

              const SizedBox(height: 28),

              // Submit CTA
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                  onPressed: _isSubmitting ? null : _submitApplication,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text('Submit Application for Verification', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
