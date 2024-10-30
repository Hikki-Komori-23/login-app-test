import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TransactionStatus { success, failure, pending }

class RecieptScreen extends StatelessWidget {
  final TransactionStatus status;
  final String? transactionAmount;
  final String? transactionDateTime;
  final String? payerName;
  final String? accountNumber;
  final String? bankName;
  final String? transactionFee;
  final String? totalAmount;
  final Widget? itemWidget;
  final Function? onClick;

  const RecieptScreen({
    super.key,
    required this.status,
    this.transactionAmount,
    this.transactionDateTime,
    this.payerName,
    this.accountNumber,
    this.bankName,
    this.transactionFee,
    this.totalAmount,
    this.itemWidget,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;
    String iconPath;

    switch (status) {
      case TransactionStatus.success:
        statusText = 'Thành công';
        statusColor = Colors.green;
        iconPath = 'assets/images/svg/success.svg';
        break;
      case TransactionStatus.failure:
        statusText = 'Tài khoản không đủ số dư';
        statusColor = Colors.red;
        iconPath = 'assets/images/svg/failure.svg';
        break;
      case TransactionStatus.pending:
        statusText = 'Chờ xử lý';
        statusColor = Colors.orange;
        iconPath = 'assets/images/svg/pending.svg';
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('eTax Mobile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            SvgPicture.asset(
              iconPath,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 10),
            Text(
              statusText,
              style: TextStyle(fontSize: 24, color: statusColor),
            ),
            const SizedBox(height: 5),
            if (transactionAmount != null && transactionAmount!.isNotEmpty)
              Text(
                '$transactionAmount VND',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            const SizedBox(height: 5),
            if (transactionDateTime != null && transactionDateTime!.isNotEmpty)
              Text(
                transactionDateTime!,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 30),
            if(itemWidget != null) ...[
              itemWidget ?? const SizedBox()
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () => onClick,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(1000, 255, 238, 230),
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.red, width: 2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Về trang chủ', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ReceiptDetailsWidget extends StatelessWidget {
  final List<Map<String, String?>> details;

  const ReceiptDetailsWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.map((detail) {
          if (detail['value'] != null && detail['value']!.isNotEmpty) {
            return TransactionDetailRow(
              label: detail['label']!,
              value: detail['value']!,
            );
          }
          return const SizedBox.shrink(); 
        }).toList(),
      ),
    );
  }
}

class TransactionDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const TransactionDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
