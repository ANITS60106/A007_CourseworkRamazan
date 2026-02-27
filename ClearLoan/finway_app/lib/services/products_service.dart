import '../models/loan_product.dart';
import 'api_client.dart';

class ProductsService {
  static Future<List<LoanProduct>> listProducts({
    String q = '',
    String filter = 'all',
    String loanType = '',
  }) async {
    final params = <String, String>{};
    if (q.trim().isNotEmpty) params['q'] = q.trim();
    if (filter.isNotEmpty) params['filter'] = filter;
    if (loanType.trim().isNotEmpty) params['loan_type'] = loanType.trim();

    final uri = Uri(path: '/api/loans/products/', queryParameters: params).toString();
    final res = await ApiClient.get(uri);
    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((j) => LoanProduct.fromJson(j)).toList();
  }
}
