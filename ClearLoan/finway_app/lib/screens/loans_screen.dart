import 'package:flutter/material.dart';
import '../services/i18n.dart';
import '../services/loans_service.dart';
import '../widgets/app_card.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  @override
  void initState() {
    super.initState();
    LoansService.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(I18n.t('loans'))),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => LoansService.refresh(),
          child: ValueListenableBuilder(
            valueListenable: LoansService.loans,
            builder: (context, loans, _) {
              if (loans.isEmpty) {
                return ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Text(
                        I18n.t('no_active_loans'),
                        style: TextStyle(color: Colors.black.withOpacity(0.55)),
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: loans.length,
                itemBuilder: (context, i) {
                  final l = loans[i];
                  return AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.bankName, style: const TextStyle(fontWeight: FontWeight.w900)),
                              const SizedBox(height: 6),
                              Text(
                                '${l.amount} сом • ${l.months} ${I18n.t('months_short')} • ${l.rate.toStringAsFixed(0)}%',
                                style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                I18n.t('monthly_payment').replaceAll('{pay}', l.monthlyPayment.toString()),
                                style: TextStyle(color: cs.primary, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
