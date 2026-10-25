import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Graceful Firebase initialization
  try {
    await Firebase.initializeApp();
    debugPrint('[Califnco Mobile] Firebase Core successfully initialized.');
  } catch (e) {
    debugPrint('[Califnco Mobile] Firebase uninitialized or running in self-contained mode: $e');
  }

  runApp(
    const ProviderScope(
      child: CalifncoApp(),
    ),
  );
}
