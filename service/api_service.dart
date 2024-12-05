import 'dart:io';
import 'package:dio/dio.dart';
import 'package:login_app_2/service/share_prefer_utils.dart';
import 'package:login_app_2/service/utils.dart';
import 'package:path_provider/path_provider.dart';

class AuthInterceptor extends Interceptor {
  final String platform = "android"; // Replace with platform detection if needed
  final String client = "store";

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Set the default content type
      options.headers['Content-Type'] = 'application/json';

      // Fetch token and user info asynchronously
      final String? token = await SharePreferUtils.getAccessToken();
      final userInfo = await SharePreferUtils.getUserInfo();

      // Add authorization header if both token and user info are available
      if (token != null && userInfo != null) {
        options.headers['Authorization'] =
            '${Utils.getCurrentTimeStringRequest()}|${userInfo.userName}|X-AUTH-TOKEN $token|DEVICE_ID ${userInfo.deviceId}';
      }

      print('Request Headers: ${options.headers}');
    } catch (e) {
      print('Error in AuthInterceptor: $e');
    }

    // Continue the request
    handler.next(options);
  }

  /// Gets the local file path for saving logs.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Retrieves the log file based on the current weekday.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${DateTime.now().weekday}.txt');
  }

  /// Writes log data to the file.
  Future<File> writeLog(String logData) async {
    final file = await _localFile;
    return file.writeAsString('$logData\n', mode: FileMode.append);
  }
}

class ApiService {
  final Dio dio;

  ApiService()
      : dio = Dio(BaseOptions(
          baseUrl: 'https://daotaothuedientu.gdt.gov.vn/ICanhanMobile2/api/',
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors.add(AuthInterceptor()); // Add the auth interceptor
  }

  /// General POST request
  Future<Response> postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    required Function(bool) showLoading,
  }) async {
    try {
      // Hiển thị loading
      showLoading(true);

      print('Sending POST request to $endpoint with body: $body');
      final response = await dio.post(endpoint, data: body);

      print('Response from $endpoint: ${response.data}');
      return response;
    } catch (e) {
      print('Error during POST request: $e');
      throw Exception('Error during POST request: $e');
    } finally {
      // Đóng loading dù thành công hay thất bại
      showLoading(false);
    }
  }

  /// Send QR code
  Future<Map<String, dynamic>> sendQRCode(
    String qrCode, {
    required Function(bool) showLoading,
  }) async {
    try {
      final response = await postRequest(
        'readCtuQrCodeAPI',
        {'qrCode': qrCode},
        showLoading: showLoading,
      );
      return response.data;
    } catch (e) {
      print('Error in sendQRCode: $e');
      throw Exception('Error occurred while sending QR code: $e');
    }
  }

  /// Lookup Tax Code
  Future<Map<String, dynamic>?> lookupTaxCode({
    required String documentType,
    required String documentNumber,
    required String captcha,
    required Function(bool) showLoading,
  }) async {
    try {
      final response = await postRequest(
        'lookupTinGip',
        {
          'document_type': documentType,
          'document_number': documentNumber,
          'captcha': captcha,
        },
        showLoading: showLoading,
      );
      return response.data;
    } catch (e) {
      print('Error in lookupTaxCode: $e');
      throw Exception('Error occurred while looking up tax code: $e');
    }
  }
}
