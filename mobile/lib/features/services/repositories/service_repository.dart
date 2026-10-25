import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_booking_model.dart';
import '../../profile/models/address_model.dart';

class ServiceRepository {
  static const String _serviceKey = 'califnco_services_cache';
  final List<ServiceBookingModel> _inMemoryBookings = [];

  ServiceRepository() {
    _loadCache();
  }

  Future<void> _loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_serviceKey);
      if (list != null && list.isNotEmpty) {
        _inMemoryBookings.clear();
        for (final item in list) {
          final map = jsonDecode(item);
          _inMemoryBookings.add(ServiceBookingModel.fromMap(map, map['id']));
        }
      } else {
        // Pre-seed an example booking for Rahul Sharma
        _inMemoryBookings.add(
          ServiceBookingModel(
            id: 'srv_demo_01',
            ticketNumber: 'CAL-SRV-1042',
            userId: 'demo_customer_01',
            customerName: 'Rahul Sharma',
            customerPhone: '+91 98765 12345',
            address: AddressModel.getDemoAddresses('demo_customer_01').first,
            serviceType: 'Filter & Membrane Replacement',
            purifierModel: 'Califnco AquaPro RO 10L',
            preferredDate: '26 Oct 2026',
            preferredTimeSlot: '11:00 AM - 01:00 PM',
            status: ServiceStatus.assigned,
            assignedTechnician: 'Suresh Kumar (+91 94480 11223)',
            notes: 'Annual filter change request and TDS calibration.',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _persistLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _inMemoryBookings.map((b) => jsonEncode(b.toMap())).toList();
      await prefs.setStringList(_serviceKey, list);
    } catch (_) {}
  }

  Future<ServiceBookingModel> bookTicket({
    required String userId,
    required String customerName,
    required String customerPhone,
    required AddressModel address,
    required String serviceType,
    required String purifierModel,
    required String preferredDate,
    required String preferredTimeSlot,
    String notes = '',
  }) async {
    final bookingId = 'srv_${DateTime.now().millisecondsSinceEpoch}';
    final randomSuffix = (1000 + (DateTime.now().microsecond % 9000));
    final ticketNumber = 'CAL-SRV-$randomSuffix';

    final booking = ServiceBookingModel(
      id: bookingId,
      ticketNumber: ticketNumber,
      userId: userId,
      customerName: customerName,
      customerPhone: customerPhone,
      address: address,
      serviceType: serviceType,
      purifierModel: purifierModel,
      preferredDate: preferredDate,
      preferredTimeSlot: preferredTimeSlot,
      status: ServiceStatus.pending,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save to Firestore if connected
    try {
      await FirebaseFirestore.instance
          .collection('serviceBookings')
          .doc(bookingId)
          .set(booking.toMap());
    } catch (_) {}

    _inMemoryBookings.insert(0, booking);
    await _persistLocal();
    return booking;
  }

  Future<List<ServiceBookingModel>> fetchUserBookings(String userId) async {
    await _loadCache();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('serviceBookings')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => ServiceBookingModel.fromMap(doc.data(), doc.id))
            .toList();
      }
    } catch (_) {}

    return _inMemoryBookings.where((b) => b.userId == userId || userId == 'demo_customer_01').toList();
  }

  Future<List<ServiceBookingModel>> fetchAllBookings() async {
    await _loadCache();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('serviceBookings')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => ServiceBookingModel.fromMap(doc.data(), doc.id))
            .toList();
      }
    } catch (_) {}

    return List.from(_inMemoryBookings);
  }

  Future<void> updateBookingStatus(
    String bookingId,
    ServiceStatus newStatus, [
    String? assignedTechnician,
  ]) async {
    try {
      await FirebaseFirestore.instance.collection('serviceBookings').doc(bookingId).update({
        'status': newStatus.name,
        if (assignedTechnician != null) 'assignedTechnician': assignedTechnician,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}

    final idx = _inMemoryBookings.indexWhere((b) => b.id == bookingId);
    if (idx >= 0) {
      final b = _inMemoryBookings[idx];
      _inMemoryBookings[idx] = ServiceBookingModel(
        id: b.id,
        ticketNumber: b.ticketNumber,
        userId: b.userId,
        customerName: b.customerName,
        customerPhone: b.customerPhone,
        address: b.address,
        serviceType: b.serviceType,
        purifierModel: b.purifierModel,
        preferredDate: b.preferredDate,
        preferredTimeSlot: b.preferredTimeSlot,
        status: newStatus,
        assignedTechnician: assignedTechnician ?? b.assignedTechnician,
        notes: b.notes,
        createdAt: b.createdAt,
        updatedAt: DateTime.now(),
      );
      await _persistLocal();
    }
  }
}
