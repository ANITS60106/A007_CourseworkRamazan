import 'package:flutter/material.dart';
import '../data/mock_offers.dart';
import '../models/bank_offer.dart';
import '../services/i18n.dart';
import '../widgets/bank_offer_card.dart';
import '../services/api_client.dart';

class AggregatorScreen extends StatefulWidget {
  const AggregatorScreen({super.key});

  @override
  State<AggregatorScreen> createState() => _AggregatorScreenState();
}

class _AggregatorScreenState extends State<AggregatorScreen> {
  final _search = TextEditingController();
  int _filter = 0; // 0 all, 1 low rate, 2 short, 3 long

  late Future<List<BankOffer>> _load;

  @override
  void initState() {
    super.initState();
    _load = _fetchOffers();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<List<BankOffer>> _fetchOffers() async {
    try {
      final list = await ApiClient.getList('/api/loans/offers/');
      final offers = list
          .whereType<Map<String, dynamic>>()
          .map(BankOffer.fromOfferJson)
          .toList();
      return offers.isEmpty ? List<BankOffer>.from(mockOffers) : offers;
    } catch (_) {
      return List<BankOffer>.from(mockOffers);
    }
  }

  List<BankOffer> _applyFilters(List<BankOffer> base) {
    var list = List<BankOffer>.from(base);

    final q = _search.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((o) => o.bankName.toLowerCase().contains(q)).toList();
    }

    if (_filter == 1) {
      list = list.where((o) => o.status != OfferStatus.rejected && o.rate <= 20).toList();
    } else if (_filter == 2) {
      list = list.where((o) => o.status != OfferStatus.rejected && o.months <= 24).toList();
    } else if (_filter == 3) {
      list = list.where((o) => o.status != OfferStatus.rejected && o.months >= 36).toList();
    }

    list.sort((a, b) => a.status.index.compareTo(b.status.index));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    

    return Scaffold(
      appBar: AppBar(title: Text(I18n.t('aggregator'))),
      body: SafeArea(
        child: FutureBuilder(
          future: _load,
          builder: (context, snap) {
            final base = snap.data ?? mockOffers;
            final offers = _applyFilters(base);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        I18n.t('best_matches'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: I18n.t('search_by_bank'),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _search.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _chip(I18n.t('filter_all'), 0, cs),
                            const SizedBox(width: 8),
                            _chip(I18n.t('filter_low'), 1, cs),
                            const SizedBox(width: 8),
                            _chip(I18n.t('filter_short'), 2, cs),
                            const SizedBox(width: 8),
                            _chip(I18n.t('filter_long'), 3, cs),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: offers.length + 1,
                    itemBuilder: (_, i) {
                      if (i == offers.length) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                          child: _SponsorFooter(cs: cs),
                        );
                      }
                      return BankOfferCard(offer: offers[i]);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _chip(String text, int value, ColorScheme cs) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: cs.primary.withOpacity(0.16),
      backgroundColor: cs.surface,
      labelStyle: TextStyle(
        color: selected ? cs.primary : Colors.black.withOpacity(0.75),
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide(color: Colors.black.withOpacity(0.08)),
    );
  }
}

class _SponsorFooter extends StatelessWidget {
  final ColorScheme cs;
  const _SponsorFooter({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.account_balance, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  I18n.t('sponsored_by'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black.withOpacity(0.55),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Айыл Банк',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
