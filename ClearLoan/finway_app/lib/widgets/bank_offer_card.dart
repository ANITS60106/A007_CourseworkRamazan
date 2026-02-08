import 'package:flutter/material.dart';
import '../models/bank_offer.dart';

class BankOfferCard extends StatelessWidget {
  final BankOffer offer;

  const BankOfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (offer.status) {
      case OfferStatus.approved:
        statusColor = Colors.green;
        statusText = 'Одобрено';
        break;
      case OfferStatus.alternative:
        statusColor = Colors.orange;
        statusText = 'Альтернатива';
        break;
      default:
        statusColor = Colors.red;
        statusText = 'Отказ';
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(offer.bankName),
        subtitle: Text('$statusText ${offer.amount} сом'),
        trailing: Icon(Icons.check_circle, color: statusColor),
      ),
    );
  }
}