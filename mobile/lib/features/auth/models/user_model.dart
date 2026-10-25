enum UserRole {
  customer,
  dealer,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.dealer:
        return 'Dealer / Wholesale';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  static UserRole fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'dealer':
        return UserRole.dealer;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }
}

enum DealerStatus {
  pending,
  approved,
  rejected;

  String get label {
    switch (this) {
      case DealerStatus.pending:
        return 'Under Review';
      case DealerStatus.approved:
        return 'Approved Partner';
      case DealerStatus.rejected:
        return 'Application Rejected';
    }
  }

  static DealerStatus? fromString(String? val) {
    if (val == null) return null;
    switch (val.toLowerCase()) {
      case 'approved':
        return DealerStatus.approved;
      case 'rejected':
        return DealerStatus.rejected;
      case 'pending':
      default:
        return DealerStatus.pending;
    }
  }
}

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String phoneNumber;
  final UserRole role;
  final DealerStatus? dealerStatus;
  final String? companyName;
  final String? gstNumber;
  final String? businessAddress;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.phoneNumber = '',
    this.role = UserRole.customer,
    this.dealerStatus,
    this.companyName,
    this.gstNumber,
    this.businessAddress,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isApprovedDealer => role == UserRole.dealer && dealerStatus == DealerStatus.approved;
  bool get isPendingDealer => role == UserRole.dealer && dealerStatus == DealerStatus.pending;
  bool get isAdmin => role == UserRole.admin;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'dealerStatus': dealerStatus?.name,
      'companyName': companyName,
      'gstNumber': gstNumber,
      'businessAddress': businessAddress,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'Califnco User',
      phoneNumber: map['phoneNumber'] ?? '',
      role: UserRole.fromString(map['role']),
      dealerStatus: DealerStatus.fromString(map['dealerStatus']),
      companyName: map['companyName'],
      gstNumber: map['gstNumber'],
      businessAddress: map['businessAddress'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? displayName,
    String? phoneNumber,
    UserRole? role,
    DealerStatus? dealerStatus,
    String? companyName,
    String? gstNumber,
    String? businessAddress,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      dealerStatus: dealerStatus ?? this.dealerStatus,
      companyName: companyName ?? this.companyName,
      gstNumber: gstNumber ?? this.gstNumber,
      businessAddress: businessAddress ?? this.businessAddress,
      createdAt: createdAt,
    );
  }
}
