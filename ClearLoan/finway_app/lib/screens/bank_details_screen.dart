import 'package:flutter/material.dart';
import '../models/bank_detail.dart';
import '../services/app_settings.dart';
import '../services/banks_service.dart';
import '../services/i18n.dart';

class BankDetailsScreen extends StatefulWidget {
  final String code;
  const BankDetailsScreen({super.key, required this.code});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  late Future<BankDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = BanksService.getBankDetail(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.t('bank_info')),
      ),
      body: FutureBuilder<BankDetail>(
        future: _future,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return Center(
              child: Text('Failed to load bank data', style: TextStyle(color: cs.error, fontWeight: FontWeight.w700)),
            );
          }
          final d = snap.data!;
          final lang = AppSettings.language.value;

          String name() => lang == 'ru' ? d.bank.nameRu : lang == 'ky' ? d.bank.nameKy : d.bank.nameEn;
          String about() => lang == 'ru' ? d.bank.aboutRu : lang == 'ky' ? d.bank.aboutKy : d.bank.aboutEn;
          String hq() => lang == 'ru' ? d.bank.hqRu : lang == 'ky' ? d.bank.hqKy : d.bank.hqEn;

          String prodTitle(LoanProduct p) =>
              lang == 'ru' ? p.titleRu : lang == 'ky' ? p.titleKy : p.titleEn;
          String prodDesc(LoanProduct p) => lang == 'ru' ? p.descRu : lang == 'ky' ? p.descKy : p.descEn;
          String branchAddr(BankBranch b) =>
              lang == 'ru' ? b.addressRu : lang == 'ky' ? b.addressKy : b.addressEn;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Header(name: name()),
              const SizedBox(height: 10),
              Text(about(), style: TextStyle(color: cs.onBackground.withOpacity(0.7), fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              _SectionTitle(title: I18n.t('hq_address')),
              _Card(child: Text(hq(), style: const TextStyle(fontWeight: FontWeight.w700))),
              const SizedBox(height: 14),
              _SectionTitle(title: I18n.t('products')),
              ...d.products.map((p) => _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prodTitle(p), style: const TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        Text(
                          '${p.rateFrom.toStringAsFixed(1)}% - ${p.rateTo.toStringAsFixed(1)}% • ${p.minMonths}-${p.maxMonths}m • ${p.minAmount}-${p.maxAmount} KGS',
                          style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(prodDesc(p), style: TextStyle(color: cs.onSurface.withOpacity(0.72))),
                      ],
                    ),
                  )),
              const SizedBox(height: 14),
              _SectionTitle(title: I18n.t('branches')),
              ...d.branches.map((b) => _Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.place, color: cs.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.city, style: const TextStyle(fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Text(branchAddr(b), style: TextStyle(color: cs.onSurface.withOpacity(0.7))),
                              if (b.hours.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(b.hours, style: TextStyle(color: cs.onSurface.withOpacity(0.55), fontSize: 12)),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  const _Header({required this.name});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.account_balance, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
      ),
      child: child,
    );
  }
}
