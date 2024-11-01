import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app_2/models/login_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginModel _loginModel; 

  LoginBloc({required LoginModel loginModel}) 
    : _loginModel = loginModel,
      super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event, 
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading()); 
    
    try {
      final token = await _loginModel.login(
        event.userName,
        event.passWord,
        event.requestId,
        event.otpNo,
        event.version,
        event.operatingSystem,
        event.token,
        event.deviceId,
        event.code,
        event.tokenPush,
        event.sodinhdanh,
      );

      if (token != null) {
        emit(LoginSuccess(username: event.userName)); 
      } else {
        emit(LoginFailure(error: "Đăng nhập không thành công"));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString())); 
    }
  }
}
