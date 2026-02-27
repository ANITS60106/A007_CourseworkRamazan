import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/app_settings.dart';
import '../services/i18n.dart';
import '../widgets/app_card.dart';
import '../widgets/lang_switcher.dart';
import 'pin_setup_screen.dart';

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
  final _income = TextEditingController(text: '30000');
  final _password = TextEditingController();

  // legal entity fields
  final _companyName = TextEditingController();
  final _companyInn = TextEditingController();
  final _companyFax = TextEditingController();
  final _companyAddress = TextEditingController();
  final _companyPhone = TextEditingController();
  final _companyDirector = TextEditingController();
  final _companyProfit = TextEditingController(text: '0');

  String? _error;
  bool _obscure = true;
  bool _loading = false;

  int get _incomeVal => int.tryParse(_income.text.replaceAll(' ', '')) ?? 0;
  int get _companyProfitVal => int.tryParse(_companyProfit.text.replaceAll(' ', '')) ?? 0;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _passport.dispose();
    _workplace.dispose();
    _occupation.dispose();
    _income.dispose();
    _password.dispose();
    _companyName.dispose();
    _companyInn.dispose();
    _companyFax.dispose();
    _companyAddress.dispose();
    _companyPhone.dispose();
    _companyDirector.dispose();
    _companyProfit.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final type = AppSettings.userType.value;

    final err = await AuthService.register(
      phone: _phone.text,
      password: _password.text,
      passportId: _passport.text,
      fullName: _fullName.text,
      workplace: _workplace.text,
      occupation: _occupation.text,
      monthlyIncome: _incomeVal,
      userType: type == 'legal' ? 'legal' : 'individual',
      companyName: type == 'legal' ? _companyName.text : null,
      companyInn: type == 'legal' ? _companyInn.text : null,
      companyFax: type == 'legal' ? _companyFax.text : null,
      companyAddress: type == 'legal' ? _companyAddress.text : null,
      companyPhone: type == 'legal' ? _companyPhone.text : null,
      companyDirector: type == 'legal' ? _companyDirector.text : null,
      companyProfitMonthly: type == 'legal' ? _companyProfitVal : null,
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
      MaterialPageRoute(builder: (_) => const PinSetupScreen()),
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
        child: ValueListenableBuilder<String>(
          valueListenable: AppSettings.userType,
          builder: (_, type, __) {
            final isLegal = type == 'legal';
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Text(
                  isLegal ? I18n.t('legal_entity') : I18n.t('individual'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  isLegal
                      ? 'Company details are required for legal entity registration (prototype).'
                      : 'Passport data is collected only during registration (prototype).',
                  style: TextStyle(color: cs.onBackground.withOpacity(0.65), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                AppCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      TextField(
                        controller: _fullName,
                        decoration: InputDecoration(labelText: I18n.t('full_name')),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: I18n.t('phone'), hintText: '+996 ...'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passport,
                        decoration: InputDecoration(labelText: I18n.t('passport_id'), hintText: 'AN1234567'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _workplace,
                        decoration: InputDecoration(labelText: I18n.t('workplace')),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _occupation,
                        decoration: InputDecoration(labelText: I18n.t('occupation')),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _income,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: I18n.t('monthly_income')),
                      ),

                      if (isLegal) ...[
                        const SizedBox(height: 18),
                        Divider(color: cs.outlineVariant.withOpacity(0.6)),
                        const SizedBox(height: 10),
                        TextField(controller: _companyName, decoration: InputDecoration(labelText: I18n.t('company_name'))),
                        const SizedBox(height: 12),
                        TextField(controller: _companyInn, decoration: InputDecoration(labelText: I18n.t('company_inn'))),
                        const SizedBox(height: 12),
                        TextField(controller: _companyAddress, decoration: InputDecoration(labelText: I18n.t('company_address'))),
                        const SizedBox(height: 12),
                        TextField(controller: _companyPhone, decoration: InputDecoration(labelText: I18n.t('company_phone'))),
                        const SizedBox(height: 12),
                        TextField(controller: _companyFax, decoration: InputDecoration(labelText: I18n.t('company_fax'))),
                        const SizedBox(height: 12),
                        TextField(controller: _companyDirector, decoration: InputDecoration(labelText: I18n.t('company_director'))),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _companyProfit,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: I18n.t('company_profit')),
                        ),
                      ],

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
                                child: Text(_error!, style: TextStyle(color: cs.error, fontWeight: FontWeight.w700)),
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
            );
          },
        ),
      ),
    );
  }
}
