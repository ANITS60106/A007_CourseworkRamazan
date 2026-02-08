import 'package:flutter/material.dart';
import 'screens/application_screen.dart';
import 'theme/app_theme.dart';

class FinwayApp extends StatelessWidget {
  const FinwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinWay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const ApplicationScreen(),
    );
  }
}