class LoanProduct {
  final int id;
  final String bankCode;
  final String bankNameEn;
  final String bankNameRu;
  final String bankNameKy;

  final String loanType;
  final String titleEn;
  final String titleRu;
  final String titleKy;

  final int minAmount;
  final int maxAmount;
  final int minMonths;
  final int maxMonths;
  final double rateFrom;
  final double rateTo;
  final String collateral;
  final bool isIslamic;

  LoanProduct({
    required this.id,
    required this.bankCode,
    required this.bankNameEn,
    required this.bankNameRu,
    required this.bankNameKy,
    required this.loanType,
    required this.titleEn,
    required this.titleRu,
    required this.titleKy,
    required this.minAmount,
    required this.maxAmount,
    required this.minMonths,
    required this.maxMonths,
    required this.rateFrom,
    required this.rateTo,
    required this.collateral,
    required this.isIslamic,
  });

  factory LoanProduct.fromJson(Map<String, dynamic> j) {
    return LoanProduct(
      id: (j['id'] ?? 0) as int,
      bankCode: (j['bank_code'] ?? '') as String,
      bankNameEn: (j['bank_name_en'] ?? '') as String,
      bankNameRu: (j['bank_name_ru'] ?? '') as String,
      bankNameKy: (j['bank_name_ky'] ?? '') as String,
      loanType: (j['loan_type'] ?? 'consumer') as String,
      titleEn: (j['title_en'] ?? '') as String,
      titleRu: (j['title_ru'] ?? '') as String,
      titleKy: (j['title_ky'] ?? '') as String,
      minAmount: (j['min_amount'] ?? 0) as int,
      maxAmount: (j['max_amount'] ?? 0) as int,
      minMonths: (j['min_months'] ?? 0) as int,
      maxMonths: (j['max_months'] ?? 0) as int,
      rateFrom: ((j['rate_from'] ?? 0) as num).toDouble(),
      rateTo: ((j['rate_to'] ?? 0) as num).toDouble(),
      collateral: (j['collateral'] ?? '') as String,
      isIslamic: (j['is_islamic'] ?? false) as bool,
    );
  }
}
