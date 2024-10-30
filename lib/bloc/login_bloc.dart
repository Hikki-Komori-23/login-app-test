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
      final token = await _loginModel.login(event.taxCode, event.password);

      if (token != null) {
        emit(LoginSuccess(username: event.taxCode)); 
      } else {
        emit(LoginFailure(error: "Mã số thuế hoặc mật khẩu không chính xác"));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString())); 
    }
  }
}
