import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  // Brand Primary & Dark Surfaces
  static const Color primaryNavy = Color(0xFF0A192F);
  static const Color secondaryNavy = Color(0xFF0F2744);
  static const Color darkCard = Color(0xFF172A45);

  // Brand Accents
  static const Color accentAqua = Color(0xFF00B4D8);
  static const Color accentTeal = Color(0xFF0077B6);
  static const Color cyanVibrant = Color(0xFF48CAE4);
  static const Color waterGlow = Color(0xFF90E0EF);

  // Functional Status
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Neutral Surfaces
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceBorder = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
}

class AppConstants {
  static const String appName = 'Califnco PureWater';
  static const String appTagline = 'Engineered Purity for Health & Life';

  static final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static const List<String> categories = [
    'All Products',
    'RO water purifiers',
    'UV water purifiers',
    'UF water purifiers',
    'Commercial water purification systems',
    'Water dispensers',
    'Water pumps',
    'RO membranes',
    'Sediment filters',
    'Carbon filters',
    'Replacement cartridges and spare parts',
  ];

  static const List<String> serviceTypes = [
    'New Purifier Installation',
    'Filter & Membrane Replacement',
    'Breakdown Repair & Troubleshooting',
    'Annual Maintenance Contract (AMC)',
    'Water TDS & Quality Testing',
  ];

  static const double standardGstRate = 0.18; // 18% GST
  static const double minWholesaleOrderAmount = 15000.0; // Minimum wholesale order amount in INR
}
