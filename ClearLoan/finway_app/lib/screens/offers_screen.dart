import 'package:flutter/material.dart';
import '../services/scoring_service.dart';
import '../widgets/bank_offer_card.dart';
import '../models/credit_application.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final offers = ScoringService.getOffers(
      CreditApplication(amount: 50000, months: 36, purpose: 'Ремонт'),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Вам скорее всего одобрят')),
      body: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return BankOfferCard(offer: offers[index]);
        },
      ),
    );
  }
}