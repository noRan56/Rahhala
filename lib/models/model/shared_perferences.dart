import 'package:shared_preferences/shared_preferences.dart';

class SharedPerferencesHelper {
  static String userId = 'USERIDKEY';
  static String userName = 'USERNAMEKEY';
  static String userEmail = 'USEREMAILKEY';
  static String userImageKey = 'USERIMAGEKEY';

  static Future<void> saveUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userId, id);
  }

  static Future<void> saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userName, name);
  }

  static Future<void> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userEmail, email);
  }

  static Future<void> saveUserImage(String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userImageKey, image);
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId);
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userName);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmail);
  }

  static Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }
}
