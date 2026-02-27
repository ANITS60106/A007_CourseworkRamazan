import 'package:flutter/material.dart';
import '../services/i18n.dart';
import '../widgets/app_card.dart';
import 'bank_options_screen.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String _loanType = 'consumer';
  double _amount = 200000;
  double _months = 24;
  final _purpose = TextEditingController();

  @override
  void dispose() {
    _purpose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(I18n.t('request'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          AppCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(I18n.t('loan_type'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _loanType,
                  items: [
                    DropdownMenuItem(value: 'mortgage', child: Text(I18n.t('loan_type_mortgage'))),
                    DropdownMenuItem(value: 'consumer', child: Text(I18n.t('loan_type_consumer'))),
                    DropdownMenuItem(value: 'auto', child: Text(I18n.t('loan_type_auto'))),
                    DropdownMenuItem(value: 'business', child: Text(I18n.t('loan_type_business'))),
                  ],
                  onChanged: (v) => setState(() => _loanType = v ?? 'consumer'),
                ),
                const SizedBox(height: 14),
                Text('${I18n.t('loan_amount')}: ${_amount.toInt()} KGS', style: Theme.of(context).textTheme.titleMedium),
                Slider(
                  value: _amount,
                  min: 10000,
                  max: 5000000,
                  divisions: 100,
                  label: _amount.toInt().toString(),
                  onChanged: (v) => setState(() => _amount = v),
                ),
                const SizedBox(height: 6),
                Text('${I18n.t('loan_term')}: ${_months.toInt()}', style: Theme.of(context).textTheme.titleMedium),
                Slider(
                  value: _months,
                  min: 3,
                  max: 120,
                  divisions: 117,
                  label: _months.toInt().toString(),
                  onChanged: (v) => setState(() => _months = v),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _purpose,
                  decoration: InputDecoration(labelText: I18n.t('purpose')),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BankOptionsScreen(
                          loanType: _loanType,
                          amount: _amount.toInt(),
                          months: _months.toInt(),
                          purpose: _purpose.text.trim(),
                        ),
                      ),
                    );
                  },
                  child: Text(I18n.t('see_options')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
