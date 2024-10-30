import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:shared_preferences/shared_preferences.dart'; 

class LoginModel {
  final String baseUrl = 'https://daotaothuedientu.gdt.gov.vn/ICanhanMobile2/api/authentication';

  Future<String?> login(String taxCode, String password) async {
    final url = Uri.parse('$baseUrl/login'); 

    try {
      final body = jsonEncode({
        'taxCode': taxCode,
        'password': password, 
      });
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        return token; 
      } else {
        print('Đăng nhập thất bại: ${response.body}');
        return null; 
      }
    } catch (e) {
      print('Lỗi: $e');
      return null;
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
}

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); 
  }

  Future<void> fetchData() async {
  final loginModel = LoginModel();  
  final token = await loginModel.getToken(); 

  if (token != null) {
    final url = Uri.parse('https://daotaothuedientu.gdt.gov.vn/ICanhanMobile2/api/authentication');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
      );

      if (response.statusCode == 200) {
        print('Data: ${response.body}');
      } else {
        print('Yêu cầu thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  } else {
    print('Không tìm thấy token. Vui lòng đăng nhập lại.');
  }
}

  Future<bool> isLoggedIn() async {
  final loginModel = LoginModel();  
  final token = await loginModel.getToken();
  return token != null;
}

