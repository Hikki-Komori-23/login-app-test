import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuMultiScreenState createState() => _MenuMultiScreenState();
}

class _MenuMultiScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đăng ký thuế'),
            Tab(text: 'Tiện ích'),
            Tab(text: 'Hỗ trợ quyết toán thuế TNCN'),
            Tab(text: 'Nộp thuế'),
            Tab(text: 'Tra cứu nghĩa vụ thuế'),
            Tab(text: 'Hỗ trợ'),
            Tab(text: 'Thiết lập cá nhân'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TaxSignInScreen(),
          UtilityScreen(),
          CalcSupportScreen(),
          TaxApplicationScreen(),
          TaxSearchScreen(),
          SupportScreen(),
          PersonalScreen(),
        ],
      ),
    );
  }
}

class IconLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconLabelButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color.fromARGB(1000, 155, 0, 0), size: 30),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class IconGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const IconGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
        children: items.map((item) => IconLabelButton(icon: item['icon'], label: item['label'])).toList(),
      ),
    );
  }
}

class TaxSignInScreen extends StatelessWidget {
  const TaxSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleMenuScreen(
      title: 'Đăng ký thuế',
      items: [
        {'icon': Icons.person, 'label': 'Thay đổi thông tin Đăng ký thuế'},
        {'icon': Icons.person_search, 'label': 'Tra cứu thông tin người phụ thuộc'},
        {'icon': Icons.edit_document, 'label': 'Tra cứu hồ sơ đăng ký thuế'},
      ],
    );
  }
}

class UtilityScreen extends StatelessWidget {
  const UtilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleMenuScreen(
      title: 'Tiện ích',
      items: [
        {'icon': Icons.calculate, 'label': 'Bảng giá tính thuế phương tiện'},
        {'icon': Icons.person_search, 'label': 'Tra cứu thông tin NNT'},
        {'icon': Icons.account_balance_wallet, 'label': 'Công cụ tính thuế TNCN'},
        {'icon': Icons.directions_car, 'label': 'Tra cứu thông tin kinh doanh'},
        {'icon': Icons.business_center, 'label': 'Phân hạng về hộ kinh doanh'},
        {'icon': Icons.qr_code_scanner, 'label': 'Quét QR-Code cho Tem rượu, thuốc lá điện tử'},
      ],
    );
  }
}

class CalcSupportScreen extends StatelessWidget {
  const CalcSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleMenuScreen(
      title: 'Hỗ trợ quyết toán thuế TNCN',
      items: [
        {'icon': Icons.search, 'label': 'Tra cứu hồ sơ thuế'},
        {'icon': Icons.image_search, 'label': 'Tra cứu hồ sơ quyết toán thuế'},
        {'icon': Icons.directions_car_outlined, 'label': 'Tra cứu hồ sơ khai Lệ phí trước bạ phương tiện'},
        {'icon': Icons.location_searching, 'label': 'Tra cứu hồ sơ đất đai'},
      ],
    );
  }
}

class TaxApplicationScreen extends StatelessWidget {
  const TaxApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleMenuScreen(
      title: 'Nộp thuế',
      items: [
        {'icon': Icons.payment, 'label': 'Nộp thuế'},
        {'icon': Icons.payments, 'label': 'Nộp thuế thay'},
        {'icon': Icons.content_paste_search_outlined, 'label': 'Tra cứu chứng từ nộp thuế'},
        {'icon': Icons.edit_note_outlined, 'label': 'Lập giấy nộp tiền thủ công'},
        {'icon': Icons.dataset_linked, 'label': 'Liên kết tài khoản'},
        {'icon': Icons.document_scanner, 'label': 'Đề nghị xử lí khoản nộp thừa'},
        {'icon': Icons.find_in_page, 'label': 'Tra cứu đề nghị xử lí khoản nộp thừa'},
        {'icon': Icons.qr_code_2, 'label': 'Quét QR để nộp thuế'},
      ],
    );
  }
}

class TaxSearchScreen extends StatelessWidget {
  const TaxSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleMenuScreen(
      title: 'Tra cứu nghĩa vụ thuế',
      items: [
        {'icon': Icons.book_outlined, 'label': 'Thông tin nghĩa vụ thuế'},
        {'icon': Icons.other_houses_outlined, 'label': 'Thông tin nghĩa vụ tài chính về đất đai'},
        {'icon': Icons.car_repair_outlined, 'label': 'Thông tin nghĩa vụ Lệ phí trước bạ phương tiện'},
      ],
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleMenuScreen(
      title: 'Hỗ trợ',
      items: [
        {'icon': Icons.integration_instructions_outlined, 'label': 'Hướng dẫn sử dụng'},
        {'icon': Icons.headphones_outlined, 'label': 'Liên hệ hỗ trợ'},
        {'icon': Icons.info_outline, 'label': 'Phiên bản ứng dụng'},
      ],
    );
  }
}

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleMenuScreen(
      title: 'Thiết lập cá nhân',
      items: [
        {'icon': Icons.image_outlined, 'label': 'Thiết lập ảnh đại diện'},
        {'icon': Icons.password_outlined, 'label': 'Đổi mật khẩu đăng nhập'},
        {'icon': Icons.fingerprint_outlined, 'label': 'Đăng nhập bằng vân tay/FaceID'},
        {'icon': Icons.account_box_outlined, 'label': 'Đăng ký kênh nhận thông tin'},
        {'icon': Icons.star_outline, 'label': 'Chức năng hay dùng'},
      ],
    );
  }
}

class SimpleMenuScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const SimpleMenuScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: IconGrid(items: items),
    );
  }
}
