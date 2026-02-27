import 'package:flutter/material.dart';
import '../services/pin_service.dart';
import '../services/i18n.dart';
import 'home_shell.dart';

class PinUnlockScreen extends StatefulWidget {
  const PinUnlockScreen({super.key});

  @override
  State<PinUnlockScreen> createState() => _PinUnlockScreenState();
}

class _PinUnlockScreenState extends State<PinUnlockScreen> {
  final _pin = TextEditingController();
  bool _wrong = false;
  bool _loading = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _wrong = false;
    });
    final ok = await PinService.verify(_pin.text.trim());
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShell()));
    } else {
      setState(() {
        _wrong = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 18),
              Icon(Icons.lock, size: 44, color: cs.primary),
              const SizedBox(height: 10),
              Text(
                I18n.t('enter_pin_title'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _pin,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: I18n.t('pin'),
                  counterText: '',
                  errorText: _wrong ? I18n.t('pin_wrong') : null,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                child: Text(I18n.t('confirm')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
