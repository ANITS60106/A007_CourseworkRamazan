import 'package:flutter/material.dart';
import '../services/options_service.dart';
import '../services/app_settings.dart';
import '../services/i18n.dart';
import 'loan_confirm_screen.dart';

class BankOptionsScreen extends StatefulWidget {
  final String loanType;
  final int amount;
  final int months;
  final String purpose;

  const BankOptionsScreen({
    super.key,
    required this.loanType,
    required this.amount,
    required this.months,
    required this.purpose,
  });

  @override
  State<BankOptionsScreen> createState() => _BankOptionsScreenState();
}

class _BankOptionsScreenState extends State<BankOptionsScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = OptionsService.scoredOptions(
      loanType: widget.loanType,
      amount: widget.amount,
      months: widget.months,
    );
  }

  String _bankName(BankOption o) {
    final lang = AppSettings.language.value;
    if (lang == 'ru') return o.bankNameRu;
    if (lang == 'ky') return o.bankNameKy;
    return o.bankNameEn;
  }

  String _productTitle(BankOption o) {
    final lang = AppSettings.language.value;
    if (lang == 'ru') return o.productTitleRu;
    if (lang == 'ky') return o.productTitleKy;
    return o.productTitleEn;
  }

  Color _statusColor(BuildContext context, String status) {
    final cs = Theme.of(context).colorScheme;
    return switch (status) {
      'approved' => cs.primary,
      'alternative' => Colors.orange,
      _ => cs.error,
    };
  }

  String _statusText(String status) {
    if (status == 'approved') return 'Approved';
    if (status == 'alternative') return 'Alternative';
    return 'Rejected';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(I18n.t('best_matches'))),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return Center(
              child: Text(
                'Login first and start backend for scoring.',
                style: TextStyle(color: cs.error, fontWeight: FontWeight.w700),
              ),
            );
          }

          final score = snap.data!['score'] as int;
          final options = (snap.data!['options'] as List<BankOption>);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: cs.primary.withOpacity(0.22)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.stacked_line_chart, color: cs.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('${I18n.t('score')}: $score', style: const TextStyle(fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...options.map((o) => InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: o.status == 'rejected'
                        ? null
                        : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LoanConfirmScreen(
                                  option: o,
                                  amount: widget.amount,
                                  months: widget.months,
                                  purpose: widget.purpose,
                                ),
                              ),
                            ),
                    child: Opacity(
                      opacity: o.status == 'rejected' ? 0.55 : 1,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _statusColor(context, o.status).withOpacity(0.14),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.account_balance, color: _statusColor(context, o.status)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_bankName(o), style: const TextStyle(fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _productTitle(o),
                                    style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${I18n.t('monthly_payment')}: ${o.estimatedPayment} KGS',
                                    style: TextStyle(color: cs.onSurface.withOpacity(0.8), fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _statusText(o.status),
                                  style: TextStyle(fontWeight: FontWeight.w900, color: _statusColor(context, o.status)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(o.approvalProbability * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
