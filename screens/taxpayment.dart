import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:login_app_2/screens/reciept.dart';

class TaxDetail {
  final int id;
  final String title;
  final String subTitle;
  final double amount;

  TaxDetail({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.amount,
  });
}

class TaxPaymentScreen extends StatefulWidget {
  final String userName;
  final String taxId;
  final String referenceId;
  final double totalAmount;

  const TaxPaymentScreen({
    super.key,
    required this.userName,
    required this.taxId,
    required this.referenceId,
    required this.totalAmount,
  });

  @override
  _TaxPaymentScreenState createState() => _TaxPaymentScreenState();
}

class _TaxPaymentScreenState extends State<TaxPaymentScreen> {
  String? selectedBank;
  String? accountType;
  String? accountNumber;
  String? otp;
  String? errorMessage;
  String? enteredAmount;

  late double calculatedTotalAmount; // Biến lưu tổng số tiền cục bộ

  final List<Map<String, String>> banks = [
    {
      'name': 'Vietcombank',
      'fullName': 'Ngân hàng thương mại cổ phần Ngoại thương Việt Nam (VCB)',
      'image': 'assets/images/svg/vietcombank.svg'
    },
    {
      'name': 'MB Bank',
      'fullName': 'Ngân hàng thương mại cổ phần Quân đội (MB)',
      'image': 'assets/images/svg/mbbank.svg'
    },
    {
      'name': 'Vietinbank',
      'fullName': 'Ngân hàng TMCP Công Thương Việt Nam (Vietinbank)',
      'image': 'assets/images/svg/vietinbank.svg'
    },
  ];

  bool get isPaymentEnabled {
    return selectedBank != null &&
        accountNumber != null &&
        accountNumber!.isNotEmpty;
  }

  final List<TaxDetail> taxDetails = [
    TaxDetail(
      id: 1,
      title: 'Thuế thu nhập cá nhân (1001)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: 2000.0,
    ),
    TaxDetail(
      id: 2,
      title: 'Tiền chậm nộp thu nhập cá nhân (4917)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: 1500000.0,
    ),
    TaxDetail(
      id: 3,
      title: 'Thuế thu nhập cá nhân (1001)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: 1500000.0,
    ),
    TaxDetail(
      id: 4,
      title:
          'Thuế giá trị gia tăng hàng sản xuất kinh doanh trong nước (1701)',
      subTitle: 'Chi cục thuế Cầu Giấy',
      amount: 3000000.0,
    ),
    TaxDetail(
      id: 5,
      title: 'Thu từ đất ở tại nông thôn (1601)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: 500000.0,
    ),
    TaxDetail(
      id: 6,
      title: 'Thu từ đất kinh doanh, sản xuất phi nông nghiệp (1603)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: 500000.0,
    ),
    TaxDetail(
      id: 7,
      title: 'Thu từ đất ở tại đô thị (1602)',
      subTitle: 'Chi cục thuế Ba Đình',
      amount: 2000000.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    calculatedTotalAmount =
        taxDetails.fold(0.0, (sum, tax) => sum + tax.amount);
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nhập mã Smart OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('(Nhập mã OTP) Smart OTP được gửi về SĐT đuôi *098'),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    otp = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handlePayment();
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

void _handlePayment() {
  double? enteredAmountValue = double.tryParse(enteredAmount ?? '');

  if (enteredAmountValue == null) {
    setState(() {
      errorMessage = 'Vui lòng nhập số tiền hợp lệ';
    });
    return;
  }

  // Check OTP validity
  if (otp == '12345678') {
    // After successful OTP verification, navigate to the ReceiptScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecieptScreen(
          // Pass relevant payment details to the ReceiptScreen
          status: enteredAmountValue == calculatedTotalAmount
              ? TransactionStatus.success
              : TransactionStatus.failure,
          transactionAmount: enteredAmountValue.toStringAsFixed(0),
          transactionDateTime: DateTime.now().toString(),
          payerName: widget.userName,
          accountNumber: accountNumber ?? '',
          bankName: banks.firstWhere(
                (bank) => bank['name'] == selectedBank,
                orElse: () => {'fullName': 'Không rõ'},
              )['fullName']!,
          transactionFee: 'Miễn phí',
          totalAmount: calculatedTotalAmount.toStringAsFixed(0),
        ),
      ),
    );
  } else {
    // If OTP is incorrect, show an error message
    setState(() {
      errorMessage = 'Mã OTP không hợp lệ';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nộp thuế'),
        backgroundColor: const Color.fromARGB(255, 155, 0, 0),
        foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tên người nộp: ${widget.userName}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Mã số thuế: ${widget.taxId}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Số tham chiếu: ${widget.referenceId}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                'Tổng số tiền: ${formatter.format(widget.totalAmount)}',
                style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32, thickness: 1),
              const Text(
                'Chi tiết khoản thuế',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: taxDetails.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final tax = taxDetails[index];
                  return ListTile(
                    title: Text(tax.title),
                    subtitle: Text(tax.subTitle),
                    trailing: Text(formatter.format(tax.amount), style: const TextStyle(color: Colors.red)),
                  );
                },
              ),
              const Divider(height: 32, thickness: 1),
              const Text(
                'Chọn ngân hàng thanh toán',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: banks.map((bank) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBank = bank['name'];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedBank == bank['name'] ? Colors.green : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              bank['image']!,
                              width: 80,
                              height: 40,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bank['name']!,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedBank != null) ...[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Số tài khoản/Số thẻ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      accountNumber = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isPaymentEnabled ? _showOtpDialog : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 155, 0, 0),
                ),
                child: const Text('Nộp thuế', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
  }
