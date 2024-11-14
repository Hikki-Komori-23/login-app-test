import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://daotaothuedientu.gdt.gov.vn/ICanhanMobile2/api/authentication';
  final String qrCodeBaseUrl = 'https://daotaothuedientu.gdt.gov.vn/ICanhanMobile2/api';

  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<Map<String, dynamic>> sendQRCode(String qrCode) async {
    const String apiEndpoint = 'readCtuQrCodeAPI';  

    try {
      final response = await postRequest(
        apiEndpoint,
        {'qrCode': qrCode},  
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);  
      } else {
        throw Exception('Failed to send QR code, HTTP status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while sending QR code: $e');
    }
  }
}
