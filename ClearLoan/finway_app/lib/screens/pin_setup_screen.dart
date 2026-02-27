import 'package:flutter/material.dart';
import '../services/pin_service.dart';
import '../services/i18n.dart';
import 'home_shell.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _pin1 = TextEditingController();
  final _pin2 = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin1.dispose();
    _pin2.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final a = _pin1.text.trim();
    final b = _pin2.text.trim();
    if (a.length != 4 || b.length != 4) {
      setState(() => _error = 'PIN must be 4 digits');
      return;
    }
    if (a != b) {
      setState(() => _error = 'PINs do not match');
      return;
    }
    await PinService.setPin(a);
    if (!mounted) return;
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
        title: Text(I18n.t('set_pin_title')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                I18n.t('set_pin_sub'),
                style: TextStyle(color: cs.onBackground.withOpacity(0.7), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pin1,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: InputDecoration(labelText: I18n.t('pin'), counterText: ''),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pin2,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: InputDecoration(labelText: I18n.t('repeat_pin'), counterText: ''),
              ),
              if (_error != null) ...[
                const SizedBox(height: 6),
                Text(_error!, style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w700)),
              ],
              const Spacer(),
              ElevatedButton(onPressed: _save, child: Text(I18n.t('save_pin'))),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeShell()),
                  (_) => false,
                ),
                child: Text(I18n.t('pin_skip')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
