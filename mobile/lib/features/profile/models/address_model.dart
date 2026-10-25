class AddressModel {
  final String id;
  final String userId;
  final String recipientName;
  final String phone;
  final String street;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phone,
    required this.street,
    this.landmark = '',
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude = 12.9716, // Default Bangalore center
    this.longitude = 77.5946,
    this.isDefault = false,
  });

  String get fullAddress =>
      '$street, ${landmark.isNotEmpty ? '$landmark, ' : ''}$city, $state - $pincode';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipientName': recipientName,
      'phone': phone,
      'street': street,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return AddressModel(
      id: id ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      recipientName: map['recipientName'] ?? '',
      phone: map['phone'] ?? '',
      street: map['street'] ?? '',
      landmark: map['landmark'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 12.9716,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 77.5946,
      isDefault: map['isDefault'] ?? false,
    );
  }

  static List<AddressModel> getDemoAddresses(String userId) {
    return [
      AddressModel(
        id: 'addr_blr_01',
        userId: userId,
        recipientName: 'Rahul Sharma',
        phone: '+91 98765 12345',
        street: 'Flat 402, Green Glen Layout, Bellandur Outer Ring Road',
        landmark: 'Opposite Cloudnine Hospital',
        city: 'Bengaluru',
        state: 'Karnataka',
        pincode: '560103',
        latitude: 12.9304,
        longitude: 77.6784,
        isDefault: true,
      ),
      AddressModel(
        id: 'addr_hyd_02',
        userId: userId,
        recipientName: 'Rahul Sharma (Office)',
        phone: '+91 98765 12345',
        street: 'Suite 300, Cyber Gateway, HITEC City',
        landmark: 'Near Cyber Towers',
        city: 'Hyderabad',
        state: 'Telangana',
        pincode: '500081',
        latitude: 17.4483,
        longitude: 78.3752,
        isDefault: false,
      ),
    ];
  }
}
