import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repo;

  AuthStateNotifier(this._repo) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await _repo.loadCachedSession();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.signInWithEmailPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> registerCustomer({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.registerCustomer(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> registerDealer({
    required String contactName,
    required String email,
    required String password,
    required String phone,
    required String companyName,
    required String gstNumber,
    required String address,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.registerDealer(
        contactName: contactName,
        email: email,
        password: password,
        phone: phone,
        companyName: companyName,
        gstNumber: gstNumber,
        address: address,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> switchDemoRole(String email) async {
    state = const AsyncValue.loading();
    _repo.switchDemoRole(email);
    state = AsyncValue.data(_repo.currentUser);
  }

  Future<void> logout() async {
    await _repo.signOut();
    state = const AsyncValue.data(null);
  }
}

final authProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repo);
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).valueOrNull;
});

final isApprovedDealerProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isApprovedDealer ?? false;
});
