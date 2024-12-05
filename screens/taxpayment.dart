import 'package:flutter/material.dart';

class TaxPaymentScreen extends StatefulWidget {
  final String taxCode; // Tên đăng nhập được truyền vào

  const TaxPaymentScreen({super.key, required this.taxCode});

  @override
  State<TaxPaymentScreen> createState() => _TaxPaymentScreenState();
}

class _TaxPaymentScreenState extends State<TaxPaymentScreen> {
  bool showDetailedPayment = false; // Toggle tổng quan và chi tiết
  Map<int, bool> visibilityMap = {}; // Quản lý trạng thái ẩn/hiện của từng mục

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nộp thuế'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị phần tổng quan luôn
            _buildOverviewView(),
          ],
        ),
      ),
    );
  }

  // Tổng quan nộp thuế
  Widget _buildOverviewView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tổng số tiền phải nộp
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const Text(
                'Tổng số tiền phải nộp',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  '9,002,000 VND',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showDetailedPayment = !showDetailedPayment;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(showDetailedPayment ? 'Ẩn chi tiết' : 'Nộp tất cả'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Hiển thị chi tiết khi "Nộp tất cả" được bật
        if (showDetailedPayment) ...[
          // Các khoản thuế
          _buildTaxGroup(
            title: 'I. Các khoản thuế, tiền chậm nộp, tiền phạt phải nộp theo thứ tự thanh toán quy định tại Điều 57 Luật Quản lý thuế.',
            totalAmount: '6,002,000 VND',
            details: [
              _buildTaxDetailItem(
                id: 1,
                title: 'Thuế thu nhập cá nhân (1001)',
                subTitle: 'Chi cục thuế Ba Đình',
                amount: '2,000 VND',
              ),
              _buildTaxDetailItem(
                id: 2,
                title: 'Tiền chậm nộp thu nhập cá nhân (4917)',
                subTitle: 'Chi cục thuế Ba Đình',
                amount: '1,500,000 VND',
              ),
              _buildTaxDetailItem(
                id: 3,
                title: 'Thuế thu nhập cá nhân (1001)',
                subTitle: 'Chi cục thuế Ba Đình',
                amount: '1,500,000 VND',
              ),
              _buildTaxDetailItem(
                id: 4,
                title: 'Thuế giá trị gia tăng hàng sản xuất kinh doanh trong nước (1701)',
                subTitle: 'Chi cục thuế Cầu Giấy',
                amount: '3,000,000 VND',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Các khoản thu khác
          _buildTaxGroup(
            title: 'II. Các khoản thu khác',
            totalAmount: '3,000,000 VND',
            details: [
              _buildTaxDetailItem(
                id: 5,
                title: 'Thu từ đất ở tại nông thôn (1601)',
                subTitle: 'Chi cục thuế Ba Đình',
                amount: '500,000 VND',
              ),
              _buildTaxDetailItem(
                id: 6,
                title: 'Thu từ đất kinh doanh, sản xuất phi nông nghiệp (1603)',
                subTitle: 'Chi cục thuế Ba Đình',
                amount: '500,000 VND',
              ),
              _buildTaxDetailItem(
                id: 7,
                title: 'Thu từ đất ở tại đô thị (1602)',
                subTitle: 'Chi cục thuế Ba Đình',
                amount: '2,000,000 VND',
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Helper widget: Nhóm khoản thuế
  Widget _buildTaxGroup({
    required String title,
    required String totalAmount,
    List<Widget> details = const [],
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tổng số tiền phải nộp: $totalAmount',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...details,
        ],
      ),
    );
  }

  // Helper widget: Chi tiết từng khoản thuế
  Widget _buildTaxDetailItem({
    required int id,
    required String title,
    required String subTitle,
    required String amount,
  }) {
    final isVisible = visibilityMap[id] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Thông tin chi tiết
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Số tiền và nút mắt
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Số tiền phải nộp:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isVisible)
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    visibilityMap[id] = !isVisible;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
