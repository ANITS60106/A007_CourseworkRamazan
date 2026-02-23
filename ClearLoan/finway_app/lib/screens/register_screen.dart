import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/i18n.dart';
import '../widgets/app_card.dart';
import '../widgets/lang_switcher.dart';
import 'home_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _passport = TextEditingController();
  final _workplace = TextEditingController();
  final _occupation = TextEditingController();
  final _income = TextEditingController(text: '0');
  final _password = TextEditingController();

  String? _error;
  bool _obscure = true;
  bool _loading = false;

  int get _incomeVal => int.tryParse(_income.text.replaceAll(' ', '')) ?? 0;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _passport.dispose();
    _workplace.dispose();
    _occupation.dispose();
    _income.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final err = await AuthService.register(
      phone: _phone.text,
      password: _password.text,
      passportId: _passport.text,
      fullName: _fullName.text,
      workplace: _workplace.text,
      occupation: _occupation.text,
      monthlyIncome: _incomeVal,
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

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.t('registration')),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LangSwitcher()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(I18n.t('create_account'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              I18n.t('passport_note'),
              style: TextStyle(color: Colors.black.withOpacity(0.55)),
            ),
            const SizedBox(height: 14),

            AppCard(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  TextField(
                    controller: _fullName,
                    decoration: InputDecoration(
                      labelText: I18n.t('full_name'),
                      hintText: 'Name Surname',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: I18n.t('phone'),
                      hintText: '+996 ...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passport,
                    decoration: InputDecoration(
                      labelText: I18n.t('passport_id'),
                      hintText: 'AN1234567',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _workplace,
                    decoration: InputDecoration(
                      labelText: I18n.t('workplace'),
                      hintText: 'Company / University',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _occupation,
                    decoration: InputDecoration(
                      labelText: I18n.t('occupation'),
                      hintText: 'Developer / Student / ...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _income,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: I18n.t('income'),
                      hintText: '30000',
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
                    onPressed: _loading ? null : _doRegister,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(I18n.t('register')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
