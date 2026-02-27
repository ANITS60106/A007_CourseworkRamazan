import 'package:flutter/material.dart';
import 'app.dart';
import 'services/app_settings.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.load();
  await AuthService.loadFromStorage();
  runApp(const FinwayApp());
}
