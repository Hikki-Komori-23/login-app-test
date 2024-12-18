
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app_2/bloc/login_bloc.dart';
import 'package:login_app_2/bloc/login_state.dart';
import 'package:login_app_2/screens/forgotpassword.dart';
import 'package:login_app_2/screens/forgotusername.dart';
import 'package:login_app_2/screens/home.dart';
import 'package:login_app_2/screens/otpverificationpassword.dart';
import 'package:login_app_2/screens/otpverificationusername.dart';
import 'package:login_app_2/service/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,  
  ]);

  runApp( 
    BlocProvider(
       create: (context) => LoginBloc(ApiService() as LoginState),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Nộp Thuế',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/forgot-username': (context) => const ForgotUsernameScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/otp-verification': (context) => const OtpVerificationScreen(newPassword: ''),
        '/otp-verification-username': (context) => OtpVerificationUsernameScreen(phoneNumber: ''),
      },
    );
  }
}
