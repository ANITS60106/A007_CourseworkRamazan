import '../models/bank.dart';
import '../models/bank_detail.dart';
import 'api_client.dart';

class BanksService {
  static Future<List<Bank>> listBanks() async {
    final res = await ApiClient.get('/api/loans/banks/');
    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((j) => Bank.fromJson(j)).toList();
  }

  static Future<BankDetail> getBankDetail(String code) async {
    final res = await ApiClient.get('/api/loans/banks/$code/');
    return BankDetail.fromJson(res as Map<String, dynamic>);
  }
}
