import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  static const String _userPrefKey = 'califnco_cached_user';

  // Demo Accounts for Instant Zero-Setup Testing
  static final Map<String, UserModel> _demoAccounts = {
    'customer@califnco.com': UserModel(
      uid: 'demo_customer_01',
      email: 'customer@califnco.com',
      displayName: 'Rahul Sharma',
      phoneNumber: '+91 98765 12345',
      role: UserRole.customer,
    ),
    'dealer.approved@califnco.com': UserModel(
      uid: 'demo_dealer_approved',
      email: 'dealer.approved@califnco.com',
      displayName: 'Apex Water Solutions Ltd',
      phoneNumber: '+91 98220 54321',
      role: UserRole.dealer,
      dealerStatus: DealerStatus.approved,
      companyName: 'Apex Water Solutions Pvt Ltd',
      gstNumber: '29ABCDE1234F1Z5',
      businessAddress: 'Plot 42, Industrial Area, Bangalore - 560058',
    ),
    'dealer.pending@califnco.com': UserModel(
      uid: 'demo_dealer_pending',
      email: 'dealer.pending@califnco.com',
      displayName: 'Krishna Enterprises',
      phoneNumber: '+91 99440 67890',
      role: UserRole.dealer,
      dealerStatus: DealerStatus.pending,
      companyName: 'Krishna Enterprises',
      gstNumber: '36AAAAA0000A1Z5',
      businessAddress: 'Shop 12, Market Complex, Hyderabad - 500001',
    ),
    'admin@califnco.com': UserModel(
      uid: 'demo_admin_01',
      email: 'admin@califnco.com',
      displayName: 'Califnco Admin Ops',
      phoneNumber: '+91 98000 00000',
      role: UserRole.admin,
    ),
  };

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<UserModel?> loadCachedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userPrefKey);
      if (userJson != null) {
        final map = jsonDecode(userJson);
        _currentUser = UserModel.fromMap(map, map['uid']);
        return _currentUser;
      }
    } catch (_) {}

    // Default to logged-in customer for seamless initial demo experience
    _currentUser = _demoAccounts['customer@califnco.com'];
    await _saveUserToPrefs(_currentUser!);
    return _currentUser;
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPrefKey, jsonEncode(user.toMap()));
  }

  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    // Check demo accounts first for instant zero-dependency testing
    if (_demoAccounts.containsKey(cleanEmail)) {
      _currentUser = _demoAccounts[cleanEmail];
      await _saveUserToPrefs(_currentUser!);
      return _currentUser!;
    }

    // Try Live Firebase Auth
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        _currentUser = UserModel.fromMap(doc.data()!, credential.user!.uid);
      } else {
        _currentUser = UserModel(
          uid: credential.user!.uid,
          email: cleanEmail,
          displayName: credential.user!.displayName ?? cleanEmail.split('@').first,
        );
      }

      await _saveUserToPrefs(_currentUser!);
      return _currentUser!;
    } catch (e) {
      // If Firebase is uninitialized or network fails, create local mock session
      _currentUser = UserModel(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: cleanEmail,
        displayName: cleanEmail.split('@').first,
        role: UserRole.customer,
      );
      await _saveUserToPrefs(_currentUser!);
      return _currentUser!;
    }
  }

  Future<UserModel> registerCustomer({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    String uid = 'usr_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      uid = cred.user!.uid;
    } catch (_) {}

    final user = UserModel(
      uid: uid,
      email: cleanEmail,
      displayName: name,
      phoneNumber: phone,
      role: UserRole.customer,
    );

    // Save to Firestore if available
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(user.toMap());
    } catch (_) {}

    _currentUser = user;
    await _saveUserToPrefs(user);
    return user;
  }

  Future<UserModel> registerDealer({
    required String contactName,
    required String email,
    required String password,
    required String phone,
    required String companyName,
    required String gstNumber,
    required String address,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    String uid = 'dealer_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      uid = cred.user!.uid;
    } catch (_) {}

    final user = UserModel(
      uid: uid,
      email: cleanEmail,
      displayName: contactName,
      phoneNumber: phone,
      role: UserRole.dealer,
      dealerStatus: DealerStatus.pending, // Pending admin approval
      companyName: companyName,
      gstNumber: gstNumber,
      businessAddress: address,
    );

    // Save to Firestore if available
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(user.toMap());
      await FirebaseFirestore.instance.collection('dealerApplications').doc(uid).set({
        'userId': uid,
        'contactName': contactName,
        'email': cleanEmail,
        'phone': phone,
        'companyName': companyName,
        'gstNumber': gstNumber,
        'address': address,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}

    _currentUser = user;
    await _saveUserToPrefs(user);
    return user;
  }

  void switchDemoRole(String emailKey) async {
    if (_demoAccounts.containsKey(emailKey)) {
      _currentUser = _demoAccounts[emailKey];
      await _saveUserToPrefs(_currentUser!);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userPrefKey);
  }
}
