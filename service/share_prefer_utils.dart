import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharePreferUtils {
  /// Save access token to SharedPreferences
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  /// Retrieve access token from SharedPreferences
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// Save user information to SharedPreferences
  static Future<void> saveUserInfo(UserInfo userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = userInfo.toJson();
    await prefs.setString('user_info', userInfoJson);
  }

  /// Retrieve user information from SharedPreferences
  static Future<UserInfo?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString('user_info');
    if (userInfoJson != null) {
      return UserInfo.fromJson(userInfoJson);
    }
    return null;
  }
}

/// User information model
class UserInfo {
  final String userName;
  final String deviceId;

  UserInfo({required this.userName, required this.deviceId});

  /// Convert object to JSON string
  String toJson() {
    return '{"userName": "$userName", "deviceId": "$deviceId"}';
  }

  /// Convert JSON string to object
  static UserInfo fromJson(String json) {
    final data = jsonDecode(json);
    return UserInfo(
      userName: data['userName'],
      deviceId: data['deviceId'],
    );
  }
}
