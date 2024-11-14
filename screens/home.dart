import 'package:flutter/material.dart';
import 'package:login_app_2/screens/forgotpassword.dart';
import 'package:login_app_2/screens/login.dart';
import 'package:login_app_2/screens/menu.dart';
import 'package:login_app_2/screens/qrscanner.dart';
import 'package:login_app_2/screens/taxcodelookup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
        foregroundColor: Colors.white,
        title: Column(
          children: [
            Image.asset(
              'assets/images/thuenhanuoc.jpg',
              height: 30,
            ),
            const Text(
              'eTax Mobile',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => const QRScannerScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/firefly.jpg'), 
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MST: 8250546540',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Nguyễn Minh Đức',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              height: 140,
              child: PageView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FunctionButton(icon: Icons.attach_money, label: 'Nộp thuế', onPressed: () {}),
                      FunctionButton(icon: Icons.info_outline, label: 'Tra cứu thông tin quyết toán', onPressed: () {}),
                      FunctionButton(icon: Icons.upload_file, label: 'Nộp thuế thay', onPressed: () {}),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FunctionButton(icon: Icons.receipt, label: 'Tra cứu biên lai', onPressed: () {}),
                      FunctionButton(icon: Icons.payment, label: 'Nộp khác', onPressed: () {}),
                      FunctionButton(icon: Icons.history, label: 'Lịch sử nộp thuế', onPressed: () {}),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FunctionButton(icon: Icons.person_search, label: 'Tra cứu mã số thuế', onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxCodeLookUpScreen()));
                      }),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  ServiceIcon(
                    icon: Icons.assignment,
                    label: 'Đăng ký thuế',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxSignInScreen()));
                    },
                  ),
                  ServiceIcon(
                    icon: Icons.assignment_turned_in,
                    label: 'Hỗ trợ quyết toán TNCN',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CalcSupportScreen()));
                    },
                  ),
                  ServiceIcon(
                    icon: Icons.find_in_page,
                    label: 'Tra cứu hồ sơ khai thuế',
                    onPressed: () {},
                  ),
                  ServiceIcon(
                    icon: Icons.payment,
                    label: 'Nộp thuế',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxApplicationScreen()));
                    },
                  ),
                  ServiceIcon(
                    icon: Icons.fact_check,
                    label: 'Tra cứu nghĩa vụ thuế',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxSearchScreen()));
                    },
                  ),
                  ServiceIcon(
                    icon: Icons.notifications,
                    label: 'Tra cứu thông báo',
                    onPressed: () {},
                  ),
                  ServiceIcon(
                    icon: Icons.apps,
                    label: 'Tiện ích',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UtilityScreen()));
                    },
                  ),
                  ServiceIcon(
                    icon: Icons.help,
                    label: 'Hỗ trợ',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                    },
                  ),
                  ServiceIcon(
                    icon: Icons.settings,
                    label: 'Thiết lập cá nhân',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: IconButton(
              icon: Icon(Icons.qr_code, size: 40, color: Color.fromARGB(255, 155, 0, 0)),
              onPressed: null,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Nguyễn Minh Đức"),
            accountEmail: const Text("MST: 8250546540"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/firefly.jpg'), 
            ),
            decoration: const BoxDecoration(
              color: Colors.red, 
            ),
            otherAccountsPictures: [
              Image.asset('assets/images/thuenhanuoc.jpg', height: 30),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                DrawerItem(
                  icon: Icons.home,
                  label: 'Trang chủ',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                  },
                ),
                DrawerItem(
                  icon: Icons.assignment,
                  label: 'Đăng ký thuế',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxSignInScreen()));
                  },
                ), 
                DrawerItem(
                  icon: Icons.assignment_turned_in,
                  label: 'Hỗ trợ quyết toán thuế TNCN',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CalcSupportScreen()));
                  },
                ),
                DrawerItem(
                  icon: Icons.find_in_page,
                  label: 'Tra cứu hồ sơ khai thuế',
                  onTap: () {},
                ),
                DrawerItem(
                  icon: Icons.payment,
                  label: 'Nộp thuế',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxApplicationScreen()));
                  },
                ),
                DrawerItem(
                  icon: Icons.fact_check,
                  label: 'Tra cứu nghĩa vụ thuế',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxSearchScreen()));
                  },
                ),
                DrawerItem(
                  icon: Icons.notifications,
                  label: 'Tra cứu thông báo',
                  onTap: () {},
                ),
                DrawerItem(
                  icon: Icons.apps,
                  label: 'Tiện ích',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UtilityScreen()));
                  },
                ),
                DrawerItem(
                  icon: Icons.settings,
                  label: 'Thiết lập cá nhân',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalScreen()));
                  },
                ),
                DrawerItem(
                  icon: Icons.fingerprint_outlined,
                  label: 'Đăng nhập bằng vân tay/FaceID',
                  onTap: () {},
                ),
                DrawerItem(
                  icon: Icons.lock,
                  label: 'Đổi mật khẩu',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            onTap: () async {
              showDialog(
                context: context, 
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator()
                  ) ;
                },
              );
              await Future.delayed(const Duration(seconds: 2));
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 155, 0, 0)),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class FunctionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FunctionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Center(
            child: IconButton(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color.fromARGB(1000, 155, 0, 0), 
                padding: const EdgeInsets.all(0), 
              ),
              icon: Icon(icon, size: 20, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.center,
          child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}

class ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ServiceIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Center(
            child: IconButton(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color.fromARGB(1000, 155, 0, 0), 
                padding: const EdgeInsets.all(0), 
              ),
              icon: Icon(icon, size: 20, color: Colors.white), 
            ),
          ),
        ),
        const SizedBox(height: 0),
        Align(
          alignment: Alignment.center,
          child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
} 