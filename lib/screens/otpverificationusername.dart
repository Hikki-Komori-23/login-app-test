import 'package:flutter/material.dart';
import 'package:login_app_2/screens/login.dart';

class OtpVerificationUsernameScreen extends StatelessWidget {
  final String phoneNumber;
  final TextEditingController otpController = TextEditingController();
  final String correctOtp = '12345678';

  OtpVerificationUsernameScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) { 
    Future.delayed(Duration.zero, () {
      showOtpBottomSheet(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác thực OTP'),
      ),
      body: const Center(
        child: Text(
          'Đang xử lý...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );  
  }

  void showOtpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nhập mã OTP đã gửi đến số điện thoại $phoneNumber.',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    labelText: 'Mã OTP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String otp = otpController.text;
                    if (otp.isNotEmpty && otpController.text == correctOtp) {
                      Navigator.pop(context); 
                      verifyOtp(context, otp);
                    } else {
                      showErrorDialog(context, 'Vui lòng nhập mã OTP hợp lệ.');
                    }
                  },
                  child: const Text('Xác nhận OTP'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void verifyOtp(BuildContext context, String otp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Mã số thuế của bạn là: 8250546540.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(), 
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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
                Navigator.pop(context); 
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
