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

  const AppUser({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.passportIdMasked,
    required this.workplace,
    required this.occupation,
    required this.monthlyIncome,
  });

  static AppUser fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] as int,
        phone: (j['phone'] ?? '') as String,
        fullName: (j['full_name'] ?? '') as String,
        passportIdMasked: (j['passport_id_masked'] ?? '') as String,
        workplace: (j['workplace'] ?? '') as String,
        occupation: (j['occupation'] ?? '') as String,
        monthlyIncome: (j['monthly_income'] ?? 0) as int,
      );
}

/// Auth via Django backend (with safe in-memory fallback for demo).
class AuthService {
  static AppUser? _current;
  static String? _token;

  // fallback: single registered user in-memory (if backend is not running)
  static Map<String, dynamic>? _localRegistered; // contains phone+password+profile

  static bool get isLoggedIn => _current != null;
  static AppUser? get currentUser => _current;
  static String? get token => _token;

  static Future<String?> register({
    required String phone,
    required String password,
    required String passportId,
    required String fullName,
    required String workplace,
    required String occupation,
    required int monthlyIncome,
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
      });

      _token = (res['token'] ?? '') as String?;
      _current = AppUser.fromJson(res['user'] as Map<String, dynamic>);
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
      };
      _current = AppUser(
        id: 1,
        phone: phone.trim(),
        fullName: fullName.trim(),
        passportIdMasked: _maskPassport(passportId.trim()),
        workplace: workplace.trim(),
        occupation: occupation.trim(),
        monthlyIncome: monthlyIncome,
      );
      _token = null;
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
      _current = AppUser.fromJson(res['user'] as Map<String, dynamic>);
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
      );
      _token = null;
      return null;
    }
  }

  static void logout() {
    _current = null;
    _token = null;
  }

  static String _maskPassport(String passport) {
    if (passport.length <= 3) return '***';
    final head = passport.substring(0, 2);
    final tail = passport.substring(passport.length - 2);
    return '$head***$tail';
  }
}
