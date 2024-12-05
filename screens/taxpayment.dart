import 'package:flutter/material.dart';
import 'package:login_app_2/service/api_service.dart';

class TaxPaymentScreen extends StatefulWidget {
  final String taxCode;

  const TaxPaymentScreen({super.key, required this.taxCode});

  @override
  State<TaxPaymentScreen> createState() => _TaxPaymentScreenState();
}

class _TaxPaymentScreenState extends State<TaxPaymentScreen> {
  final ApiService apiService = ApiService(); // Sử dụng ApiService
  List<dynamic> taxDetails = [];
  bool isLoading = true;
  bool showDetailedPayment = false; // Toggle chi tiết
  Map<int, bool> visibilityMap = {}; // Quản lý trạng thái hiển thị chi tiết

  @override
  void initState() {
    super.initState();
    _loadTaxDetails();
  }

  Future<void> _loadTaxDetails() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Gọi hàm lấy chi tiết khoản thuế
      final details = await apiService.lookupTaxCode(
        documentType: "tax",
        documentNumber: widget.taxCode,
        captcha: "dummyCaptcha", // Thay bằng mã captcha nếu cần
        showLoading: (loading) => setState(() {
          isLoading = loading;
        }),
      );
      if (details != null) {
        setState(() {
          taxDetails = details['taxDetails'] ?? [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tax details: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendTaxPayment() async {
    try {
      // Lấy danh sách ID từ taxDetails
      List<int> paymentIds = taxDetails.map((detail) => detail['id'] as int).toList();

      // Gửi thanh toán
      await apiService.postRequest(
        'submitTaxPayment',
        {
          'taxCode': widget.taxCode,
          'paymentIds': paymentIds,
        },
        showLoading: (loading) => setState(() {
          isLoading = loading;
        }),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment sent successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nộp thuế'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
              Center(
                child: Text(
                  '${_calculateTotalAmount()} VND',
                  style: const TextStyle(
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
                  onPressed: _sendTaxPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Nộp tất cả'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (showDetailedPayment) _buildTaxGroup(),
      ],
    );
  }

  // Helper: Tính tổng số tiền
  String _calculateTotalAmount() {
    double total = taxDetails.fold(0, (sum, detail) => sum + (detail['amount'] as double));
    return total.toStringAsFixed(0);
  }

  // Hiển thị danh sách khoản thuế
  Widget _buildTaxGroup() {
    return Column(
      children: taxDetails.map((detail) {
        return _buildTaxDetailItem(
          id: detail['id'],
          title: detail['title'],
          subTitle: detail['subTitle'],
          amount: detail['amount'],
        );
      }).toList(),
    );
  }

  // Helper: Chi tiết khoản thuế
  Widget _buildTaxDetailItem({
    required int id,
    required String title,
    required String subTitle,
    required double amount,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
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
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  if (isVisible)
                    Text(
                      '${amount.toStringAsFixed(0)} VND',
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
