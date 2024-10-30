import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String taxCode;
  final String password;

  LoginSubmitted({required this.taxCode, required this.password});

  @override
  List<Object?> get props => [taxCode, password];
}
