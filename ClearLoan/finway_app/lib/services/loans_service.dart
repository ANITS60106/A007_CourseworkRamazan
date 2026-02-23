import 'package:flutter/foundation.dart';
import '../models/active_loan.dart';
import 'api_client.dart';
import 'auth_service.dart';

class LoansService {
  static final ValueNotifier<List<ActiveLoan>> loans =
      ValueNotifier<List<ActiveLoan>>([]);

  static Future<void> refresh() async {
    final token = AuthService.token;
    if (token == null) {
      loans.value = [];
      return;
    }
    try {
      final list = await ApiClient.getList(
        '/api/loans/loans/',
        headers: {'Authorization': 'Token $token'},
      );
      loans.value = list
          .whereType<Map<String, dynamic>>()
          .map(ActiveLoan.fromJson)
          .toList();
    } catch (_) {
      // keep current
    }
  }

  static void addLoan(ActiveLoan loan) {
    loans.value = [...loans.value, loan];
  }

  static void removeAt(int index) {
    final list = [...loans.value];
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      loans.value = list;
    }
  }
}
