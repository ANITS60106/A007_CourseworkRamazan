import '../models/bank_offer.dart';

final mockOffers = [
  BankOffer(
    bankName: 'Eldik Bank',
    amount: 45000,
    months: 45,
    rate: 22,
    status: OfferStatus.approved,
  ),
  BankOffer(
    bankName: 'Bakai Bank',
    amount: 45000,
    months: 36,
    rate: 22,
    status: OfferStatus.approved,
  ),
  BankOffer(
    bankName: 'Demir Bank',
    amount: 39000,
    months: 36,
    rate: 24,
    status: OfferStatus.alternative,
  ),
  BankOffer(
    bankName: 'Kompanion Bank',
    amount: 25000,
    months: 36,
    rate: 12,
    status: OfferStatus.alternative,
  ),
  BankOffer(
    bankName: 'Finca Bank',
    amount: 0,
    months: 0,
    rate: 0,
    status: OfferStatus.rejected,
  ),
];