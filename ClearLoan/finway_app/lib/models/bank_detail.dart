import 'bank.dart';

class BankBranch {
  final String city;
  final String addressEn;
  final String addressRu;
  final String addressKy;
  final String hours;

  const BankBranch({
    required this.city,
    required this.addressEn,
    required this.addressRu,
    required this.addressKy,
    required this.hours,
  });

  static BankBranch fromJson(Map<String, dynamic> j) => BankBranch(
        city: (j['city'] ?? '') as String,
        addressEn: (j['address_en'] ?? '') as String,
        addressRu: (j['address_ru'] ?? '') as String,
        addressKy: (j['address_ky'] ?? '') as String,
        hours: (j['hours'] ?? '') as String,
      );
}

class LoanProduct {
  final int id;
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
  final String descEn;
  final String descRu;
  final String descKy;

  const LoanProduct({
    required this.id,
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
    required this.descEn,
    required this.descRu,
    required this.descKy,
  });

  static LoanProduct fromJson(Map<String, dynamic> j) => LoanProduct(
        id: j['id'] as int,
        loanType: (j['loan_type'] ?? '') as String,
        titleEn: (j['title_en'] ?? '') as String,
        titleRu: (j['title_ru'] ?? '') as String,
        titleKy: (j['title_ky'] ?? '') as String,
        minAmount: (j['min_amount'] ?? 0) as int,
        maxAmount: (j['max_amount'] ?? 0) as int,
        minMonths: (j['min_months'] ?? 0) as int,
        maxMonths: (j['max_months'] ?? 0) as int,
        rateFrom: (j['rate_from'] ?? 0).toDouble(),
        rateTo: (j['rate_to'] ?? 0).toDouble(),
        collateral: (j['collateral'] ?? '') as String,
        isIslamic: (j['is_islamic'] ?? false) as bool,
        descEn: (j['desc_en'] ?? '') as String,
        descRu: (j['desc_ru'] ?? '') as String,
        descKy: (j['desc_ky'] ?? '') as String,
      );
}

class BankDetail {
  final Bank bank;
  final List<BankBranch> branches;
  final List<LoanProduct> products;

  const BankDetail({required this.bank, required this.branches, required this.products});

  static BankDetail fromJson(Map<String, dynamic> j) => BankDetail(
        bank: Bank.fromJson(j),
        branches: ((j['branches'] ?? []) as List).map((e) => BankBranch.fromJson(e)).toList(),
        products: ((j['products'] ?? []) as List).map((e) => LoanProduct.fromJson(e)).toList(),
      );
}
