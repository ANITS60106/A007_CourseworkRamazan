import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'i18n.dart';

class AppUser {
  final int id;
  final String phone;
  final String fullName;
  final String passportIdMasked;
  final String workplace;
  final String occupation;
  final int monthlyIncome;

  final String userType; // individual/legal
  final String? companyName;

  const AppUser({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.passportIdMasked,
    required this.workplace,
    required this.occupation,
    required this.monthlyIncome,
    required this.userType,
    this.companyName,
  });

  static AppUser fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] as int,
        phone: (j['phone'] ?? '') as String,
        fullName: (j['full_name'] ?? '') as String,
        passportIdMasked: (j['passport_id_masked'] ?? '') as String,
        workplace: (j['workplace'] ?? '') as String,
        occupation: (j['occupation'] ?? '') as String,
        monthlyIncome: (j['monthly_income'] ?? 0) as int,
        userType: (j['user_type'] ?? 'individual') as String,
        companyName: j['company_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'full_name': fullName,
        'passport_id_masked': passportIdMasked,
        'workplace': workplace,
        'occupation': occupation,
        'monthly_income': monthlyIncome,
        'user_type': userType,
        'company_name': companyName,
      };
}

/// Auth via Django backend (with safe in-memory fallback for demo).
class AuthService {
  static AppUser? _current;
  static String? _token;

  // fallback: registered user in-memory (if backend is not running)
  static Map<String, dynamic>? _localRegistered;

  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';

  static bool get isLoggedIn => _current != null;
  static AppUser? get currentUser => _current;
  static String? get token => _token;

  static Future<void> loadFromStorage() async {
    final sp = await SharedPreferences.getInstance();
    final t = sp.getString(_kToken);
    final u = sp.getString(_kUser);
    if (u != null && u.isNotEmpty) {
      try {
        _current = AppUser.fromJson(jsonDecode(u) as Map<String, dynamic>);
      } catch (_) {}
    }
    if (t != null && t.isNotEmpty) {
      _token = t;
      ApiClient.setToken(t);
    }
  }

  static Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    if (_token != null) {
      await sp.setString(_kToken, _token!);
    } else {
      await sp.remove(_kToken);
    }
    if (_current != null) {
      await sp.setString(_kUser, jsonEncode(_current!.toJson()));
    } else {
      await sp.remove(_kUser);
    }
  }

  static Future<String?> register({
    required String phone,
    required String password,
    required String passportId,
    required String fullName,
    required String workplace,
    required String occupation,
    required int monthlyIncome,
    required String userType,
    String? companyName,
    String? companyInn,
    String? companyFax,
    String? companyAddress,
    String? companyPhone,
    String? companyDirector,
    int? companyProfitMonthly,
  }) async {
    if (phone.trim().isEmpty || password.trim().isEmpty) {
      return I18n.t('required_phone_password');
    }

    try {
      final res = await ApiClient.post('/api/auth/register/', body: {
        'phone': phone.trim(),
        'password': password,
        'passport_id': passportId.trim(),
        'full_name': fullName.trim(),
        'workplace': workplace.trim(),
        'occupation': occupation.trim(),
        'monthly_income': monthlyIncome,
        'user_type': userType,
        'company_name': companyName ?? '',
        'company_inn': companyInn ?? '',
        'company_fax': companyFax ?? '',
        'company_address': companyAddress ?? '',
        'company_phone': companyPhone ?? '',
        'company_director': companyDirector ?? '',
        'company_profit_monthly': companyProfitMonthly ?? 0,
      });

      _token = (res['token'] ?? '') as String?;
      final userJson = (res['user'] ?? {}) as Map<String, dynamic>;
      _current = AppUser.fromJson(userJson);
      if (_token != null && _token!.isNotEmpty) ApiClient.setToken(_token);
      await _save();
      return null;
    } catch (_) {
      // fallback local
      _localRegistered = {
        'phone': phone.trim(),
        'password': password,
        'passport_id': passportId.trim(),
        'full_name': fullName.trim(),
        'workplace': workplace.trim(),
        'occupation': occupation.trim(),
        'monthly_income': monthlyIncome,
        'user_type': userType,
        'company_name': companyName,
      };
      _current = AppUser(
        id: 1,
        phone: phone.trim(),
        fullName: fullName.trim(),
        passportIdMasked: _maskPassport(passportId.trim()),
        workplace: workplace.trim(),
        occupation: occupation.trim(),
        monthlyIncome: monthlyIncome,
        userType: userType,
        companyName: companyName,
      );
      _token = null;
      await _save();
      return null;
    }
  }

  static Future<String?> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await ApiClient.post('/api/auth/login/', body: {
        'phone': phone.trim(),
        'password': password,
      });

      _token = (res['token'] ?? '') as String?;
      final userJson = (res['user'] ?? {}) as Map<String, dynamic>;
      _current = AppUser.fromJson(userJson);
      if (_token != null && _token!.isNotEmpty) ApiClient.setToken(_token);
      await _save();
      return null;
    } catch (_) {
      // fallback local
      if (_localRegistered == null) return I18n.t('no_user');
      if ((_localRegistered!['phone'] as String) != phone.trim()) {
        return I18n.t('incorrect_phone');
      }
      if ((_localRegistered!['password'] as String) != password) {
        return I18n.t('incorrect_password');
      }
      _current = AppUser(
        id: 1,
        phone: phone.trim(),
        fullName: _localRegistered!['full_name'] as String,
        passportIdMasked: _maskPassport(_localRegistered!['passport_id'] as String),
        workplace: _localRegistered!['workplace'] as String,
        occupation: _localRegistered!['occupation'] as String,
        monthlyIncome: _localRegistered!['monthly_income'] as int,
        userType: (_localRegistered!['user_type'] ?? 'individual') as String,
        companyName: _localRegistered!['company_name'] as String?,
      );
      _token = null;
      await _save();
      return null;
    }
  }

  static Future<void> logout() async {
    _current = null;
    _token = null;
    ApiClient.setToken(null);
    await _save();
  }

  static String _maskPassport(String passport) {
    if (passport.length <= 3) return '***';
    final head = passport.substring(0, 2);
    final tail = passport.substring(passport.length - 2);
    return '$head***$tail';
  }
}
