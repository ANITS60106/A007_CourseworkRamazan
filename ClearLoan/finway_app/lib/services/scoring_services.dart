import '../models/credit_application.dart';
import '../models/bank_offer.dart';
import '../data/mock_offers.dart';
import 'api_client.dart';
import 'auth_service.dart';

class ScoringService {
  static List<BankOffer> getOffers(CreditApplication application) {
    // Offline fallback (if backend isn't running)
    return mockOffers;
  }

  static Future<List<BankOffer>> getOffersScored(CreditApplication application) async {
    final token = AuthService.token;
    if (token == null) {
      // If not logged in with token, use offline fallback
      return getOffers(application);
    }
    try {
      final q = '?amount=${application.amount}&months=${application.months}';
      final map = await ApiClient.getMap(
        '/api/loans/offers/scored/$q',
        headers: {'Authorization': 'Token $token'},
      );

      final offers = (map['offers'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(BankOffer.fromScoredJson)
          .toList();

      return offers.isEmpty ? getOffers(application) : offers;
    } catch (_) {
      return getOffers(application);
    }
  }
}