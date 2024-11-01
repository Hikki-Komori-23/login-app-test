import 'package:flutter/material.dart';
import 'package:login_app_2/screens/login.dart';
import 'package:login_app_2/screens/otpverificationusername.dart';

class ForgotUsernameScreen extends StatefulWidget {
  const ForgotUsernameScreen({super.key});

  @override
  _ForgotUsernameScreenState createState() => _ForgotUsernameScreenState();
}

class _ForgotUsernameScreenState extends State<ForgotUsernameScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên mã số thuế'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nhập số điện thoại của bạn để nhận mã OTP và lấy lại mã số thuế',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String phone = phoneController.text;
                if (phone.isNotEmpty) {
                  sendOtp(context, phone);
                } else {
                  showErrorDialog(context, 'Vui lòng nhập số điện thoại hợp lệ.');
                }
              },
              child: const Text('Gửi mã OTP'),
            ),
          ],
        ),
      ),
    );
  }

  void sendOtp(BuildContext context, String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationUsernameScreen(phoneNumber: phoneNumber),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
