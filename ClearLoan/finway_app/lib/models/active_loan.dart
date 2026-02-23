class ActiveLoan {
  final String bankName;
  final int amount;
  final int months;
  final double rate;
  final int monthlyPayment;

  const ActiveLoan({
    required this.bankName,
    required this.amount,
    required this.months,
    required this.rate,
    required this.monthlyPayment,
  });

  factory ActiveLoan.fromJson(Map<String, dynamic> j) {
    return ActiveLoan(
      bankName: (j['provider_name'] ?? j['bankName'] ?? '') as String,
      amount: (j['amount'] ?? 0) as int,
      months: (j['months'] ?? 0) as int,
      rate: ((j['rate'] ?? 0) as num).toDouble(),
      monthlyPayment: (j['monthly_payment'] ?? j['monthlyPayment'] ?? 0) as int,
    );
  }
}
