import 'package:flutter/material.dart';
import '../../profile/models/address_model.dart';
import '../../../core/constants.dart';

enum ServiceStatus {
  pending,
  assigned,
  inProgress,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case ServiceStatus.pending:
        return 'Request Received';
      case ServiceStatus.assigned:
        return 'Technician Assigned';
      case ServiceStatus.inProgress:
        return 'Service In Progress';
      case ServiceStatus.completed:
        return 'Completed';
      case ServiceStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case ServiceStatus.pending:
        return AppColors.warningOrange;
      case ServiceStatus.assigned:
        return AppColors.infoBlue;
      case ServiceStatus.inProgress:
        return AppColors.accentTeal;
      case ServiceStatus.completed:
        return AppColors.successGreen;
      case ServiceStatus.cancelled:
        return AppColors.errorRed;
    }
  }

  static ServiceStatus fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'assigned':
        return ServiceStatus.assigned;
      case 'inprogress':
      case 'in_progress':
        return ServiceStatus.inProgress;
      case 'completed':
        return ServiceStatus.completed;
      case 'cancelled':
        return ServiceStatus.cancelled;
      case 'pending':
      default:
        return ServiceStatus.pending;
    }
  }
}

class ServiceBookingModel {
  final String id;
  final String ticketNumber;
  final String userId;
  final String customerName;
  final String customerPhone;
  final AddressModel address;
  final String serviceType;
  final String purifierModel;
  final String preferredDate;
  final String preferredTimeSlot;
  final ServiceStatus status;
  final String? assignedTechnician;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceBookingModel({
    required this.id,
    required this.ticketNumber,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.serviceType,
    required this.purifierModel,
    required this.preferredDate,
    required this.preferredTimeSlot,
    required this.status,
    this.assignedTechnician,
    this.notes = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'address': address.toMap(),
      'serviceType': serviceType,
      'purifierModel': purifierModel,
      'preferredDate': preferredDate,
      'preferredTimeSlot': preferredTimeSlot,
      'status': status.name,
      'assignedTechnician': assignedTechnician,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ServiceBookingModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return ServiceBookingModel(
      id: docId ?? map['id'] ?? '',
      ticketNumber: map['ticketNumber'] ?? 'CAL-SRV-0000',
      userId: map['userId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      address: AddressModel.fromMap(Map<String, dynamic>.from(map['address'] ?? {})),
      serviceType: map['serviceType'] ?? 'Purifier Installation',
      purifierModel: map['purifierModel'] ?? 'Califnco AquaPro RO',
      preferredDate: map['preferredDate'] ?? 'Tomorrow',
      preferredTimeSlot: map['preferredTimeSlot'] ?? '10:00 AM - 01:00 PM',
      status: ServiceStatus.fromString(map['status']),
      assignedTechnician: map['assignedTechnician'],
      notes: map['notes'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) ?? DateTime.now() : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now() : DateTime.now(),
    );
  }
}
