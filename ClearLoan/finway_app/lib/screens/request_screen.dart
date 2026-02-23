import 'package:flutter/material.dart';
import '../services/i18n.dart';
import '../models/credit_application.dart';
import 'offers_screen.dart';
import '../widgets/app_card.dart';

enum LoanType { mortgage, consumer, auto, business, education }

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  LoanType _type = LoanType.consumer;

  final _amount = TextEditingController(text: '50000');
  final _months = TextEditingController(text: '36');
  final _purpose = TextEditingController(text: '');

  int get _amountVal => int.tryParse(_amount.text.replaceAll(' ', '')) ?? 0;
  int get _monthsVal => int.tryParse(_months.text) ?? 0;

  int _monthlyPayment() {
    if (_monthsVal <= 0) return 0;
    return (_amountVal / _monthsVal).round();
  }

  @override
  void dispose() {
    _amount.dispose();
    _months.dispose();
    _purpose.dispose();
    super.dispose();
  }

  String _typeLabel(LoanType t) => switch (t) {
        LoanType.mortgage => I18n.t('mortgage'),
        LoanType.consumer => I18n.t('consumer'),
        LoanType.auto => I18n.t('auto'),
        LoanType.business => I18n.t('business'),
        LoanType.education => I18n.t('education'),
      };

  void _submit() {
    final amount = _amountVal;
    final months = _monthsVal;

    if (amount <= 0 || months <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(I18n.t('enter_valid_terms'))),
      );
      return;
    }

    final app = CreditApplication(
      amount: amount,
      months: months,
      purpose: _purpose.text.trim(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OffersScreen(application: app)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(I18n.t('request'))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              I18n.t('loan_request'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              I18n.t('request_hint'),
              style: TextStyle(color: Colors.black.withOpacity(0.55)),
            ),
            const SizedBox(height: 14),

            AppCard(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(I18n.t('choose_loan_type'), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: LoanType.values.map((t) {
                      final selected = t == _type;
                      return ChoiceChip(
                        label: Text(_typeLabel(t)),
                        selected: selected,
                        onSelected: (_) => setState(() => _type = t),
                        selectedColor: cs.primary.withOpacity(0.16),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: selected ? cs.primary : Colors.black.withOpacity(0.75),
                        ),
                        side: BorderSide(color: Colors.black.withOpacity(0.08)),
                        backgroundColor: cs.surface,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: I18n.t('amount_som')),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _months,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: I18n.t('term_months')),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _purpose,
                    decoration: InputDecoration(labelText: I18n.t('purpose')),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            AppCard(
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    I18n.t('estimated_payment'),
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      '${_monthlyPayment()} сом',
                      key: ValueKey(_monthlyPayment()),
                      style: TextStyle(color: cs.primary, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _submit,
              child: Text(I18n.t('submit_request')),
            ),
          ],
        ),
      ),
    );
  }
}
