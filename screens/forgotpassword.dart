import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'package:flutter/material.dart';
import 'package:login_app_2/screens/otpverificationpassword.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taxCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _showPassword1 = false;
  bool _showPassword2 = false;

  final String apiUrl = 'https://daotaothuedientu.gdt.gov.vn/ICanhanMobile2/api/changePassNNT';

  void _togglePasswordView1() {
    setState(() {
      _showPassword1 = !_showPassword1;
    });
  }

  void _togglePasswordView2() {
    setState(() {
      _showPassword2 = !_showPassword2;
    });
  }

  Future<void> _changePassword(String taxId, String newPassword) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'taxId': taxId,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                newPassword: newPasswordController.text,
              ),
            ),
          );
        } else {
          _showErrorDialog('Lỗi', jsonResponse['message']);
        }
      } else {
        _showErrorDialog('Lỗi', 'Thay đổi mật khẩu thất bại. Vui lòng thử lại.');
      }
    } catch (e) {
      _showErrorDialog('Lỗi', 'Có lỗi xảy ra. Vui lòng thử lại.');
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _changePassword(taxCodeController.text, newPasswordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thay đổi mật khẩu'),
        backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: taxCodeController,
                decoration: const InputDecoration(
                  labelText: 'Mã số thuế *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã số thuế.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: newPasswordController,
                obscureText: !_showPassword1,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới *',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword1 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordView1,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới.';
                  } else if (value.length < 6 || value.length > 20) {
                    return 'Mật khẩu phải dài từ 6 đến 20 ký tự.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !_showPassword2,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới *',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword2 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordView2,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu.';
                  } else if (value != newPasswordController.text) {
                    return 'Mật khẩu không khớp.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Mật khẩu truy cập phải dài từ 6 đến 20 ký tự và không có dấu cách (khoảng trống) bao gồm chữ thường, chữ hoa, chữ số, ký tự đặc biệt.',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Tiếp tục', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
