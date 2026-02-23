import '../models/credit_history_entry.dart';
import 'api_client.dart';
import 'auth_service.dart';

class CreditHistoryService {
  static Future<List<CreditHistoryEntry>> fetchEntries() async {
    final token = AuthService.token;
    if (token == null) return [];
    final list = await ApiClient.getList(
      '/api/loans/credit-history/',
      headers: {'Authorization': 'Token $token'},
    );
    return list
        .whereType<Map<String, dynamic>>()
        .map(CreditHistoryEntry.fromJson)
        .toList();
  }

  static Future<Map<String, dynamic>> fetchSummary() async {
    final token = AuthService.token;
    if (token == null) return {'score': 0, 'counts': {}};
    return ApiClient.getMap(
      '/api/loans/credit-history/summary/',
      headers: {'Authorization': 'Token $token'},
    );
  }
}
