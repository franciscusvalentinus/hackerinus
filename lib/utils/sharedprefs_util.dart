import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil{
  static const String _isLoggedIn = 'isLoggedIn';
  static const String _email = 'email';
  static const String _phone = 'phone';
  static const String _name = 'name';
  static const String _joinedDate = 'userJoinDate';

  static Future<bool> getIsLoggedIn() async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(_isLoggedIn) ?? false;
  }

  static Future<String> getEmail() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(_email) ?? "";
  }

  static Future<String> getPhone() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(_phone) ?? "";
  }

  static Future<String> getJoinedDate() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(_joinedDate) ?? "";
  }

  static Future<String> getName() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(_name) ?? "";
  }

  static Future<void> setIsLogin(bool status) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(_isLoggedIn, status);
  }

  static Future<void> setEmail(String email) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_email, email);
  }

  static Future<void> setPhone(String phone) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_phone, phone);
  }

  static Future<void> setJoinedDate(String date) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_joinedDate, date);
  }

  static Future<void> setName(String name) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_name, name);
  }



}