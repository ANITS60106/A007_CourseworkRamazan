import 'api_client.dart';

class BankOption {
  final int productId;
  final String bankCode;
  final String bankNameEn;
  final String bankNameRu;
  final String bankNameKy;
  final String productTitleEn;
  final String productTitleRu;
  final String productTitleKy;
  final String loanType;
  final double rateFrom;
  final double rateTo;
  final int estimatedPayment;
  final double approvalProbability;
  final String status; // approved/alternative/rejected

  const BankOption({
    required this.productId,
    required this.bankCode,
    required this.bankNameEn,
    required this.bankNameRu,
    required this.bankNameKy,
    required this.productTitleEn,
    required this.productTitleRu,
    required this.productTitleKy,
    required this.loanType,
    required this.rateFrom,
    required this.rateTo,
    required this.estimatedPayment,
    required this.approvalProbability,
    required this.status,
  });

  static BankOption fromJson(Map<String, dynamic> j) => BankOption(
        productId: j['product_id'] as int,
        bankCode: (j['bank_code'] ?? '') as String,
        bankNameEn: (j['bank_name_en'] ?? '') as String,
        bankNameRu: (j['bank_name_ru'] ?? '') as String,
        bankNameKy: (j['bank_name_ky'] ?? '') as String,
        productTitleEn: (j['product_title_en'] ?? '') as String,
        productTitleRu: (j['product_title_ru'] ?? '') as String,
        productTitleKy: (j['product_title_ky'] ?? '') as String,
        loanType: (j['loan_type'] ?? '') as String,
        rateFrom: (j['rate_from'] ?? 0).toDouble(),
        rateTo: (j['rate_to'] ?? 0).toDouble(),
        estimatedPayment: (j['estimated_payment'] ?? 0) as int,
        approvalProbability: (j['approval_probability'] ?? 0).toDouble(),
        status: (j['status'] ?? '') as String,
      );
}

class OptionsService {
  static Future<Map<String, dynamic>> scoredOptions({
    required String loanType,
    required int amount,
    required int months,
  }) async {
    final res = await ApiClient.get(
      '/api/loans/options/scored/?loan_type=$loanType&amount=$amount&months=$months',
    );
    final score = (res['score'] ?? 0) as int;
    final opts = ((res['options'] ?? []) as List).map((e) => BankOption.fromJson(e)).toList();
    return {'score': score, 'options': opts};
  }

  static Future<Map<String, dynamic>> apply({
    required int productId,
    required int amount,
    required int months,
  }) async {
    final res = await ApiClient.post('/api/loans/applications/apply/', body: {
      'product_id': productId,
      'amount': amount,
      'months': months,
    });
    return (res as Map<String, dynamic>);
  }
}
