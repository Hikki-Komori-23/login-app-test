// ignore_for_file: equal_keys_in_map

import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:shared_preferences/shared_preferences.dart'; 

class LoginModel {
  final String baseUrl = 'https://daotaothuedientu.gdt.gov.vn/ICanhanMobile2/api/authentication';

  Future<String?> login(
    String userName, 
    String passWord, 
    String requestId, 
    String otpNo, 
    String version,
    String operatingSystem,
    String token,
    String deviceId,
    String code,
    String tokenPush,
    String sodinhdanh) 
    async {
    final url = Uri.parse('$baseUrl/login'); 

    try {
      final body = jsonEncode({
         requestId: "20231103121111",
         userName: "8250546540",
         passWord: "111111",
         otpNo: "",
         version: "1.0",
         operatingSystem: "android",
         token: "",
         deviceId: "Android SDK built for x86",
         code: "",
         tokenPush: "cznYpkvbTHO-jK-yN-72-c:APA91bE_Mz_R-GJ424T7_sIAgcYD1YMRrfu4HUj3AqPdMQHVUE3yhr-7fmhRq3UdlUDb-ky56HiEtzSBtmDU-LRlElaz6HQeiuILbiwspF1E81pbu1ykrvBXtO1ofczx7OuNbu34tYjx",
         sodinhdanh: "",
      });
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);
      final authCode = data['authCode'];

      handleAuthCode(authCode); 

      if (authCode == 'AUTH00') {
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return token; 
      } else {
        return null;
      }
      
    } catch (e) {
      print('Lỗi: $e');
      return null;
    }
  }

  void handleAuthCode(String authCode) {
    switch (authCode) {
      case 'AUTH00':
        print('Success: AUTH00 - Đăng nhập thành công.');
        break;
      case 'AUTH01':
        print('Error: AUTH01 - Sai tài khoản hoặc mật khẩu.');
        break;
      case 'AUTH02':
        print('Error: AUTH02 - Không tìm thấy thông tin khách hàng.');
        break;
      case 'AUTH06':
        print('Error: AUTH06 - Tài khoản chưa đăng kí dịch vụ');
        break;
      case 'AUTH13':
        print('Error: AUTH13 - Lỗi OTP.');
        break;
      case 'AUTH15':
        print('Error: AUTH15 - Phiên bản cần cập nhật');
        break;
      case 'AUTH16':
        print('Error: AUTH16 - Đã đăng nhập ở một thiết bị khác.');
        break;
      case 'AUTH18':
        print('Error: AUTH18 - Mã số thuế không hợp lệ.');
        break;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); 
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); 
  }
  
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
