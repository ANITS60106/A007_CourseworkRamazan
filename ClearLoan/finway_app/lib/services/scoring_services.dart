import '../models/credit_application.dart';
import '../models/bank_offer.dart';
import '../data/mock_offers.dart';

class ScoringService {
  static List<BankOffer> getOffers(CreditApplication application) {
    // В реальности здесь AI / скоринг
    return mockOffers;
  }
}