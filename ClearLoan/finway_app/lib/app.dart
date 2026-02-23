import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/app_settings.dart';
import 'services/i18n.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_shell.dart';

class FinwayApp extends StatelessWidget {
  const FinwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppSettings.language,
      builder: (_, __, ___) {
        return MaterialApp(
          title: I18n.t('app_name'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          home: const AuthGate(),
        );
      },
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    if (AuthService.isLoggedIn) return const HomeShell();
    return const LoginScreen();
  }
}
