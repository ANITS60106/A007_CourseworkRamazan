class Bank {
  final String code;
  final String nameEn;
  final String nameRu;
  final String nameKy;
  final String website;
  final String supportPhone;
  final String hqEn;
  final String hqRu;
  final String hqKy;
  final String aboutEn;
  final String aboutRu;
  final String aboutKy;

  const Bank({
    required this.code,
    required this.nameEn,
    required this.nameRu,
    required this.nameKy,
    required this.website,
    required this.supportPhone,
    required this.hqEn,
    required this.hqRu,
    required this.hqKy,
    required this.aboutEn,
    required this.aboutRu,
    required this.aboutKy,
  });

  static Bank fromJson(Map<String, dynamic> j) => Bank(
        code: (j['code'] ?? '') as String,
        nameEn: (j['name_en'] ?? '') as String,
        nameRu: (j['name_ru'] ?? '') as String,
        nameKy: (j['name_ky'] ?? '') as String,
        website: (j['website'] ?? '') as String,
        supportPhone: (j['support_phone'] ?? '') as String,
        hqEn: (j['hq_address_en'] ?? '') as String,
        hqRu: (j['hq_address_ru'] ?? '') as String,
        hqKy: (j['hq_address_ky'] ?? '') as String,
        aboutEn: (j['about_en'] ?? '') as String,
        aboutRu: (j['about_ru'] ?? '') as String,
        aboutKy: (j['about_ky'] ?? '') as String,
      );
}
