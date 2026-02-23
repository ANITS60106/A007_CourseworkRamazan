enum OfferStatus {
  approved,
  alternative,
  rejected,
}

class BankOffer {
  final String bankName;
  final int maxAmount;
  final int months;
  final double rate;
  final OfferStatus status;
  final int recommendedAmount;
  final int estimatedPayment;

  BankOffer({
    required this.bankName,
    required this.maxAmount,
    required this.months,
    required this.rate,
    required this.status,
    required this.recommendedAmount,
    required this.estimatedPayment,
  });

  factory BankOffer.fromScoredJson(Map<String, dynamic> j) {
    final s = (j['status'] ?? 'alternative') as String;
    final status = switch (s) {
      'approved' => OfferStatus.approved,
      'rejected' => OfferStatus.rejected,
      _ => OfferStatus.alternative,
    };
    return BankOffer(
      bankName: (j['provider_name'] ?? '') as String,
      rate: ((j['rate'] ?? 0) as num).toDouble(),
      months: (j['months'] ?? 0) as int,
      maxAmount: (j['max_amount'] ?? 0) as int,
      status: status,
      recommendedAmount: (j['recommended_amount'] ?? 0) as int,
      estimatedPayment: (j['estimated_payment'] ?? 0) as int,
    );
  }

  factory BankOffer.fromOfferJson(Map<String, dynamic> j) {
    return BankOffer(
      bankName: (j['provider_name'] ?? '') as String,
      rate: ((j['rate'] ?? 0) as num).toDouble(),
      months: (j['months'] ?? 0) as int,
      maxAmount: (j['max_amount'] ?? 0) as int,
      status: OfferStatus.alternative,
      recommendedAmount: 0,
      estimatedPayment: 0,
    );
  }
}