enum OfferStatus {
  approved,
  alternative,
  rejected,
}

class BankOffer {
  final String bankName;
  final int amount;
  final int months;
  final double rate;
  final OfferStatus status;

  BankOffer({
    required this.bankName,
    required this.amount,
    required this.months,
    required this.rate,
    required this.status,
  });
}