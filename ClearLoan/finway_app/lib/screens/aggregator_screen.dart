import 'package:flutter/material.dart';
import '../services/app_settings.dart';
import '../services/i18n.dart';
import '../services/products_service.dart';
import '../models/loan_product.dart';
import 'bank_details_screen.dart';

class AggregatorScreen extends StatefulWidget {
  const AggregatorScreen({super.key});

  @override
  State<AggregatorScreen> createState() => _AggregatorScreenState();
}

class _AggregatorScreenState extends State<AggregatorScreen> {
  late Future<List<LoanProduct>> _future;
  String _q = '';
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _future = ProductsService.listProducts();
  }

  void _reload() {
    _future = ProductsService.listProducts(q: _q, filter: _filter);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(I18n.t('aggregator'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            TextField(
              onChanged: (v) {
                setState(() {
                  _q = v.trim();
                  _reload();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: I18n.t('search_by_bank'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chip('all', I18n.t('filter_all')),
                  _chip('low', I18n.t('filter_low')),
                  _chip('short', I18n.t('filter_short')),
                  _chip('long', I18n.t('filter_long')),
                  _chip('high_amount', I18n.t('filter_high_amount')),
                  _chip('best_value', I18n.t('filter_best_value')),
                  _chip('no_collateral', I18n.t('filter_no_collateral')),
                  _chip('islamic', I18n.t('filter_islamic')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<LoanProduct>>(
                future: _future,
                builder: (_, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(
                      child: Text(
                        'Backend is not reachable. Start Django server, then refresh.',
                        style: TextStyle(color: cs.error, fontWeight: FontWeight.w700),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: (snap.data ?? []).length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _ProductCard(
                      product: (snap.data ?? [])[i],
                      filter: _filter,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${I18n.t('sponsored_by')}: Айыл Банк',
                style: TextStyle(color: cs.onBackground.withOpacity(0.55), fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String value, String label) {
    final active = _filter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: active,
        label: Text(label),
        onSelected: (_) {
          setState(() {
            _filter = value;
            _reload();
          });
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final LoanProduct product;
  final String filter;

  const _ProductCard({
    required this.product,
    required this.filter,
  });

  String _bankName(BuildContext context) {
    final lang = AppSettings.language.value;
    if (lang == 'ru') return product.bankNameRu;
    if (lang == 'ky') return product.bankNameKy;
    return product.bankNameEn;
  }

  String _title(BuildContext context) {
    final lang = AppSettings.language.value;
    if (lang == 'ru') return product.titleRu;
    if (lang == 'ky') return product.titleKy;
    return product.titleEn;
  }

  String _rateLabel() {
    final from = product.rateFrom.toStringAsFixed(1);
    final to = product.rateTo.toStringAsFixed(1);
    if (product.rateFrom == product.rateTo || product.rateTo == 0) return '$from%';
    return '$from–$to%';
  }

  String _amountLabel() {
    return '${product.minAmount}–${product.maxAmount}';
  }

  String _termLabel() {
    return '${product.minMonths}–${product.maxMonths}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BankDetailsScreen(code: product.bankCode)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.35 : 0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.account_balance, color: cs.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_bankName(context), style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(
                    _title(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: cs.onSurface.withOpacity(0.65), fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _tag(context, Icons.percent, _rateLabel()),
                      _tag(context, Icons.payments, _amountLabel()),
                      _tag(context, Icons.schedule, _termLabel()),
                      if (product.isIslamic) _tag(context, Icons.mosque, I18n.t('filter_islamic')),
                      if ((product.collateral).toLowerCase().contains('none') || product.collateral.isEmpty)
                        _tag(context, Icons.shield_outlined, I18n.t('filter_no_collateral')),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, IconData icon, String text) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withOpacity(0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.primary),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.primary)),
        ],
      ),
    );
  }
}
