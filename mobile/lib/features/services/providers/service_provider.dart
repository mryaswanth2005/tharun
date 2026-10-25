import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_booking_model.dart';
import '../repositories/service_repository.dart';
import '../../auth/providers/auth_provider.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

final userServiceBookingsProvider = FutureProvider<List<ServiceBookingModel>>((ref) async {
  final repo = ref.watch(serviceRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return repo.fetchUserBookings(user.uid);
});

final allServiceBookingsProvider = FutureProvider<List<ServiceBookingModel>>((ref) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return repo.fetchAllBookings();
});
