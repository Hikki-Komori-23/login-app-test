import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:login_app_2/service/api_service.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_app_2/models/login_response_model.dart'; 

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService = ApiService();
  String? temporaryToken;

  LoginBloc(super.initialState) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<CloseLoadingRequested>(_onCloseLoadingRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      // Sử dụng Dio để gửi yêu cầu
      final response = await apiService.postRequest(
        'login',
        event.authentication.toJson(),
      );

      // Truy cập dữ liệu phản hồi
      final data = response.data; // Trong Dio, dữ liệu phản hồi nằm trong `response.data`
      final loginResponse = loginResponseFromJson(data);

      await _handleLoginResponse(loginResponse, emit);
    } catch (e) {
      emit(LoginFailure('Error: ${e.toString()}'));
    }
  }

  Future<void> _handleLoginResponse(LoginResponse loginResponse, Emitter<LoginState> emit) async {
    final responseCode = loginResponse.responseCode ?? 'UNKNOWN';

    if (responseCode == 'AUTH00' && loginResponse.token != null) {
      final prefs = await SharedPreferences.getInstance();
      bool isFirstLogin = prefs.getBool('is_first_login') ?? true;

      if (isFirstLogin) {
        temporaryToken = loginResponse.token;
        emit(LoginOtpRequired());
      } else {
        await _saveLoginData(prefs, loginResponse);
        emit(LoginSuccess(loginResponse.token!));
      }
    } else {
      emit(LoginFailure('Login failed: ${getAuthCodeMessage(responseCode)}'));
    }
  }

  Future<void> _saveLoginData(SharedPreferences prefs, LoginResponse loginResponse) async {
    await prefs.setString('auth_token', loginResponse.token!);
    await prefs.setString('login_response', jsonEncode(loginResponse.toJson()));
    if (loginResponse.userName != null) {
      await prefs.setString('ma_so_thue', loginResponse.userName!);
    }
    await prefs.setBool('is_first_login', false);
  }

  Future<void> _onOtpSubmitted(OtpSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      // Gửi yêu cầu xác minh OTP
      final response = await apiService.postRequest(
        'verify_otp',
        {'otp': event.otp, 'token': temporaryToken},
      );

      // Truy cập dữ liệu phản hồi
      final data = response.data; // Trong Dio, dữ liệu phản hồi nằm trong `response.data`
      if (data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await _saveLoginData(prefs, LoginResponse(token: temporaryToken));
        emit(LoginSuccess(temporaryToken!));
      } else {
        emit(const LoginFailure('OTP không hợp lệ. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(LoginFailure('Error: ${e.toString()}'));
    }
  }

  void _onCloseLoadingRequested(CloseLoadingRequested event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<LoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    emit(LoginInitial());
  }

  String getAuthCodeMessage(String responseCode) {
    switch (responseCode) {
      case 'AUTH01':
        return 'Sai tài khoản hoặc mật khẩu.';
      case 'AUTH02':
        return 'Không tìm thấy thông tin khách hàng.';
      case 'AUTH06':
        return 'Tài khoản chưa đăng ký dịch vụ.';
      case 'AUTH13':
        return 'Lỗi OTP.';
      case 'AUTH15':
        return 'Phiên bản cần cập nhật.';
      case 'AUTH16':
        return 'Đã đăng nhập ở một thiết bị khác.';
      case 'AUTH18':
        return 'Mã số thuế không hợp lệ.';
      case 'ERROR500':
        return 'Lỗi hệ thống.';
      default:
        return 'Lỗi không xác định.';
    }
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