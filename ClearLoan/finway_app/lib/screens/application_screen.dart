import 'package:flutter/material.dart';
import 'offers_screen.dart';
import '../models/credit_application.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final _amountCtrl = TextEditingController();
  final _monthsCtrl = TextEditingController();
  final _purposeCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _monthsCtrl.dispose();
    _purposeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = int.tryParse(_amountCtrl.text.trim());
    final months = int.tryParse(_monthsCtrl.text.trim());
    final purpose = _purposeCtrl.text.trim();

    if (amount == null || months == null || purpose.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполни поля корректно')),
      );
      return;
    }

    final application = CreditApplication(
      amount: amount,
      months: months,
      purpose: purpose,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OffersScreen(application: application),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заявка на кредит')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Сумма кредита'),
            ),
            TextField(
              controller: _monthsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Срок (мес)'),
            ),
            TextField(
              controller: _purposeCtrl,
              decoration: const InputDecoration(labelText: 'Цель кредита'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Подать заявку'),
            ),
          ],
        ),
      ),
    );
  }
}