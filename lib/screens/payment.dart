import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_app_2/screens/home.dart';
import 'package:login_app_2/screens/reciept.dart';

class PaymentScreen extends StatefulWidget {
  final String userName;
  final String taxId;
  final String referenceId;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.userName,
    required this.taxId,
    required this.referenceId,
    required this.totalAmount,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedBank;
  String? accountType;
  String? accountNumber;
  String? otp;
  String? errorMessage;
  String? enteredAmount;
  
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
           accountType != null &&
           accountNumber != null &&
           accountNumber!.isNotEmpty &&
           otp != null &&
           otp!.isNotEmpty;
  }

void _handlePayment() {
  double? enteredAmountValue = double.tryParse(enteredAmount ?? '');

  if (enteredAmountValue == null) {
    setState(() {
      errorMessage = 'Vui lòng nhập số tiền hợp lệ';
    });
    return;
  }

  if (otp == '12345678') {
    if (enteredAmountValue == widget.totalAmount) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecieptScreen(
            status: TransactionStatus.success,
            transactionAmount: enteredAmountValue.toStringAsFixed(0),
            transactionDateTime: DateTime.now().toString(),
            payerName: widget.userName,
            accountNumber: accountNumber ?? '',
            bankName: banks.firstWhere((bank) => bank['name'] == selectedBank)['fullName'] ?? '',
            transactionFee: 'Miễn phí',
            totalAmount: widget.totalAmount.toStringAsFixed(0), 
          ),
        ),
      );
    } else if (enteredAmountValue < widget.totalAmount) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecieptScreen(
            status: TransactionStatus.failure,
            transactionAmount: enteredAmountValue.toStringAsFixed(0),
            transactionDateTime: DateTime.now().toString(),
            payerName: widget.userName,
            accountNumber: accountNumber ?? '',
            bankName: banks.firstWhere((bank) => bank['name'] == selectedBank)['fullName'] ?? '',
            transactionFee: 'Miễn phí',
            totalAmount: widget.totalAmount.toStringAsFixed(0), 
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecieptScreen(
            status: TransactionStatus.pending,
            transactionAmount: enteredAmountValue.toStringAsFixed(0),
            transactionDateTime: DateTime.now().toString(),
            payerName: widget.userName,
            accountNumber: accountNumber ?? '',
            bankName: banks.firstWhere((bank) => bank['name'] == selectedBank)['fullName'] ?? '',
            transactionFee: 'Miễn phí',
            totalAmount: widget.totalAmount.toStringAsFixed(0), 
            itemWidget: const ReceiptDetailsWidget(
              details: [
                {'label': 'Số tiền nộp', 'value': "totalAmount"},
                {'label': 'Tên người nộp', 'value': "payerName"},
                {'label': 'Số tài khoản/Số thẻ', 'value': "accountNumber"},
                {'label': 'NH thanh toán', 'value': "bankName"},
                {'label': 'Phí giao dịch', 'value': "transactionFee"},
              ],
            ),
            onClick: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
        ),
      );
    }
  } else {
    setState(() {
      errorMessage = 'Mã OTP không hợp lệ';
    });
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Nộp thuế'),
      backgroundColor: const Color.fromARGB(255, 155, 0, 0),
      foregroundColor: Colors.white,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.userName.isNotEmpty)
            Text(
              'Tên người nộp: ${widget.userName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 8),

          if (widget.taxId.isNotEmpty)
            Text(
              'Mã số thuế: ${widget.taxId}',
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 8),

          if (widget.referenceId.isNotEmpty)
            Text(
              'Số tham chiếu: ${widget.referenceId}',
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 8),

          if (widget.totalAmount > 0)
            Text(
              'Số tiền phải nộp: ${widget.totalAmount.toStringAsFixed(0)} VND',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
            const Text(
              'Chọn ngân hàng thanh toán',
              style: TextStyle(fontSize: 16),
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
                        accountType = null;
                        accountNumber = null;
                        otp = null;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),  
                      constraints: const BoxConstraints(
                        maxWidth: 140, 
                        maxHeight: 80, 
                      ),
                      decoration: BoxDecoration(
                        border: selectedBank == bank['name']
                            ? Border.all(color: Colors.green, width: 2)  
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            bank['image']!,
                            width: 100,  
                            height: 50,  
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),  
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),  
            if (selectedBank != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       '${banks.firstWhere((bank) => bank['name'] == selectedBank)['fullName']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),  
                    DropdownButton<String>(
                      value: accountType,
                      hint: const Text('Chọn loại liên kết'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Tài khoản ngân hàng',
                          child: Text('Tài khoản ngân hàng'),
                        ),
                        DropdownMenuItem(
                          value: 'Thẻ ngân hàng',
                          child: Text('Thẻ ngân hàng'),
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          accountType = value;
                        });
                      },
                    ),
                      const SizedBox(height: 16),  
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
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Số tiền nộp',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            enteredAmount = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Mã OTP',
                          border: const OutlineInputBorder(),
                          errorText: errorMessage,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            otp = value;
                            errorMessage = null;
                          });
                        },
                      ),
                    ],
                  ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(1000, 255, 238, 230),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Liên kết thêm tài khoản',
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: isPaymentEnabled ? _handlePayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPaymentEnabled ? Colors.red : Colors.grey,
                  foregroundColor:  Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
