import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app_2/bloc/login_bloc.dart';
import 'package:login_app_2/bloc/login_event.dart';
import 'package:login_app_2/bloc/login_state.dart';
import 'package:login_app_2/models/authentication_model.dart';
import 'package:login_app_2/screens/forgotpassword.dart';
import 'package:login_app_2/screens/forgotusername.dart';
import 'package:login_app_2/screens/home.dart';

class LoginScreen extends StatefulWidget {
  final String? newPassword;

  const LoginScreen({super.key, this.newPassword});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taxCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    if (widget.newPassword != null) {
      passwordController.text = widget.newPassword!;
    }
  }

  void _togglePasswordView() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingDialog();
      },
    );
  }

void _submit() {
  if (_formKey.currentState!.validate()) {
    _showLoadingDialog(); 

    final authenticationModel = Authentication(
      requestId: "20231103121111",
      userName: taxCodeController.text,
      passWord: passwordController.text,
      otpNo: "",
      version: "1.0",
      operatingSystem: "android",
      token: "",
      deviceId: "Android SDK built for x86",
      code: "",
      tokenPush: "cznYpkvbTHO-jK-yN-72-c:APA91bE_Mz_R-GJ424T7_sIAgcYD1YMRrfu4HUj3AqPdMQHVUE3yhr-7fmhRq3UdlUDb-ky56HiEtzSBtmDU-LRlElaz6HQeiuILbiwspF1E81pbu1ykrvBXtO1ofczx7OuNbu34tYjx",
      sodinhdanh: "",
    );

    BlocProvider.of<LoginBloc>(context).add(LoginSubmitted(authenticationModel));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/backgroundimage.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  } else if (state is LoginFailure) {
                    Navigator.pop(context); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Image.asset(
                        'assets/images/thuenhanuoc.jpg',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'eTax Mobile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: taxCodeController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person, color: Colors.white),
                                hintText: 'Mã số thuế *',
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.5),
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mã số thuế';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: passwordController,
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock, color: Colors.white),
                                hintText: 'Mật khẩu *',
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.5),
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: _togglePasswordView,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotUsernameScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Quên mã số thuế?',
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final newPassword = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordScreen(),
                                ),
                              );
                              if (newPassword != null) {
                                setState(() {
                                  passwordController.text = newPassword;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Mật khẩu đã được cập nhật. Vui lòng đăng nhập lại.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            child: state is LoginLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Đăng nhập',
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 18),
                          IconButton(
                            iconSize: 40,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.fingerprint,
                              color: Colors.white,
                            ),
                            tooltip: 'Xác thực bằng vân tay',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Đăng nhập bằng tài khoản Định danh điện tử',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Image.asset(
                              'assets/images/vneid.jpg',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Bạn chưa có tài khoản?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Đăng ký ngay',
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
