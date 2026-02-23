import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/i18n.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/lang_switcher.dart';
import 'register_screen.dart';
import 'home_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String? _error;
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final err = await AuthService.login(
      phone: _phone.text,
      password: _password.text,
    );

    if (!mounted) return;

    if (err != null) {
      setState(() {
        _loading = false;
        _error = err;
      });
      return;
    }

    setState(() => _loading = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Row(
              children: [
                const Spacer(),
                const LangSwitcher(),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.brandGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.account_balance, color: AppTheme.brandGreen, size: 34),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              I18n.t('app_name'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              'Fintech credit navigator (prototype)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withOpacity(0.55)),
            ),
            const SizedBox(height: 18),

            AppCard(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(I18n.t('login'), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: I18n.t('phone'),
                      hintText: '+996 700 123 456',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: I18n.t('password'),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _error == null
                        ? const SizedBox(height: 0, key: ValueKey('noerr'))
                        : Padding(
                            key: const ValueKey('err'),
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(_error!, style: TextStyle(color: cs.error, fontWeight: FontWeight.w600)),
                          ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loading ? null : _doLogin,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(I18n.t('login')),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            ),
                    child: Text(I18n.t('registration')),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            Text(
              'Tip: start Django backend on port 8000 for real DB. Otherwise, the app uses local demo auth.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withOpacity(0.45), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
