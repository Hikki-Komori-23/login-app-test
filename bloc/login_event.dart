import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String userName;
  final String passWord;
  final String requestId;
  final String otpNo;
  final String version;
  final String operatingSystem;
  final String token;
  final String deviceId;
  final String code;
  final String tokenPush;
  final String sodinhdanh;

  LoginSubmitted({
    required this.userName,
    required this.passWord,
    required this.requestId,
    required this.otpNo,
    required this.version,
    required this.operatingSystem,
    required this.token,
    required this.deviceId,
    required this.code,
    required this.tokenPush,
    required this.sodinhdanh,
  });
  @override
  List<Object?> get props => [userName, passWord];
}
