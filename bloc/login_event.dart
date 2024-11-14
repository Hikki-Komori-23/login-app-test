// login_event.dart
import 'package:equatable/equatable.dart';
import 'package:login_app_2/models/authentication_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final Authentication authentication;

  const LoginSubmitted(this.authentication);
}

class OtpSubmitted extends LoginEvent {
  final String otp;
  const OtpSubmitted(this.otp);
}

class LogoutRequested extends LoginEvent {}

class CloseLoadingRequested extends LoginEvent {}