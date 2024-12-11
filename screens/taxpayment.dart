import 'package:flutter/material.dart';

/// Mô hình dữ liệu đại diện cho từng khoản thuế
class TaxDetail {
  final int id;
  final String title;
  final String subTitle;
  final String amount;

  TaxDetail({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.amount,
  });
}

/// Màn hình nộp thuế
class TaxPaymentScreen extends StatefulWidget {
  final String taxCode;

  const TaxPaymentScreen({super.key, required this.taxCode});

  @override
  State<TaxPaymentScreen> createState() => _TaxPaymentScreenState();
}

class _TaxPaymentScreenState extends State<TaxPaymentScreen> {
  bool showDetailedPayment = false; // Toggle tổng quan và chi tiết
  Map<int, bool> visibilityMap = {}; // Quản lý trạng thái ẩn/hiện của từng mục

  // Dữ liệu động danh sách các khoản thuế
  final List<TaxDetail> taxDetails = [
    TaxDetail(
      id: 1,
      title: 'Thuế thu nhập cá nhân (1001)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: '2,000 VND',
    ),
    TaxDetail(
      id: 2,
      title: 'Tiền chậm nộp thu nhập cá nhân (4917)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: '1,500,000 VND',
    ),
    TaxDetail(
      id: 3,
      title: 'Thuế thu nhập cá nhân (1001)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: '1,500,000 VND',
    ),
    TaxDetail(
      id: 4,
      title: 'Thuế giá trị gia tăng hàng sản xuất kinh doanh trong nước (1701)',
      subTitle: 'Chi cục thuế Cầu Giấy',
      amount: '3,000,000 VND',
    ),
    TaxDetail(
      id: 5,
      title: 'Thu từ đất ở tại nông thôn (1601)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: '500,000 VND',
    ),
    TaxDetail(
      id: 6,
      title: 'Thu từ đất kinh doanh, sản xuất phi nông nghiệp (1603)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: '500,000 VND',
    ),
    TaxDetail(
      id: 7,
      title: 'Thu từ đất ở tại đô thị (1602)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: '2,000,000 VND',
    ),
  ];

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

        if (showDetailedPayment)
          _buildTaxGroup(
            title: 'Chi tiết các khoản thuế',
            totalAmount: '9,002,000 VND',
            details: taxDetails,
          ),
      ],
    );
  }

  Widget _buildTaxGroup({
    required String title,
    required String totalAmount,
    required List<TaxDetail> details,
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
          ...details.map((tax) => _buildTaxDetailItem(tax)),
        ],
      ),
    );
  }

  Widget _buildTaxDetailItem(TaxDetail tax) {
    final isVisible = visibilityMap[tax.id] ?? true;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tax.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tax.subTitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
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
                      tax.amount,
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
                    visibilityMap[tax.id] = !isVisible;
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
