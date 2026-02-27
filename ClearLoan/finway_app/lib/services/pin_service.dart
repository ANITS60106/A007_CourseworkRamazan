import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  static const _kPinHash = 'pin_hash';

  static Future<bool> hasPin() async {
    final sp = await SharedPreferences.getInstance();
    final h = sp.getString(_kPinHash);
    return h != null && h.isNotEmpty;
  }

  static String _hash(String pin) => sha256.convert(utf8.encode(pin)).toString();

  static Future<void> setPin(String pin) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kPinHash, _hash(pin));
  }

  static Future<bool> verify(String pin) async {
    final sp = await SharedPreferences.getInstance();
    final h = sp.getString(_kPinHash);
    if (h == null || h.isEmpty) return false;
    return h == _hash(pin);
  }

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kPinHash);
  }
}
