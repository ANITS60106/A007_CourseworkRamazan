import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'services/app_settings.dart';
import 'services/i18n.dart';
import 'services/auth_service.dart';
import 'services/pin_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_shell.dart';
import 'screens/welcome_screen.dart';
import 'screens/pin_unlock_screen.dart';

class FinwayApp extends StatelessWidget {
  const FinwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppSettings.language,
      builder: (_, __, ___) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppSettings.themeMode,
          builder: (_, mode, ___) {
            return MaterialApp(
              title: I18n.t('app_name'),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: mode,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ru'),
                Locale('ky'),
              ],
              home: const AuthGate(),
            );
          },
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
  late Future<bool> _needPin;

  @override
  void initState() {
    super.initState();
    _needPin = _checkPin();
  }

  Future<bool> _checkPin() async {
    if (!AuthService.isLoggedIn) return false;
    return await PinService.hasPin();
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isLoggedIn) return const WelcomeScreen();

    return FutureBuilder<bool>(
      future: _needPin,
      builder: (_, snap) {
        final need = snap.data ?? false;
        if (need) return const PinUnlockScreen();
        return const HomeShell();
      },
    );
  }
}
