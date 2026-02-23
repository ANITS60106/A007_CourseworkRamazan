import 'package:flutter/material.dart';
import '../services/scoring_services.dart';
import '../services/i18n.dart';
import '../widgets/bank_offer_card.dart';
import '../models/credit_application.dart';

class OffersScreen extends StatelessWidget {
  final CreditApplication application;

  const OffersScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.t('offers'))),
      body: FutureBuilder(
        future: ScoringService.getOffersScored(application),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final offers = snap.data ?? [];
          if (offers.isEmpty) {
            return Center(child: Text(I18n.t('no_offers')));
          }
          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              return BankOfferCard(offer: offers[index]);
            },
          );
        },
      ),
    );
  }
}