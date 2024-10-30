import 'package:flutter/material.dart';
import 'package:login_app_2/screens/login.dart';

Future<void> updatePassword(String newPassword) async {
  await Future.delayed(const Duration(seconds: 1));

  bool isUpdateSuccess = true;

  if (!isUpdateSuccess) {
  }
}

class OtpVerificationScreen extends StatefulWidget {
  final String newPassword;

  const OtpVerificationScreen({super.key, required this.newPassword});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final String correctOtp = "12345678";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOtpBottomSheet(context);
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _submitOtp(BuildContext context) {
    if (otpController.text.isNotEmpty && otpController.text == correctOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP đã xác nhận thành công.')),
      );

      _onOtpVerified(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xin hãy nhập đúng mã OTP.')),
      );
    }
  }

  void _onOtpVerified(BuildContext context) {
    updatePassword(widget.newPassword).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu đã được cập nhật thành công!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(newPassword: widget.newPassword),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật mật khẩu thất bại: $error')),
      );
    });
  }

  void _showOtpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nhập mã OTP đã gửi đến số điện thoại của bạn:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  decoration: const InputDecoration(
                    labelText: 'Mã OTP *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _submitOtp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận OTP'),
        backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
      ),
      body: const Center(
        child: Text('Đang chuẩn bị xác thực OTP...'),
      ),
    );
  }
}
