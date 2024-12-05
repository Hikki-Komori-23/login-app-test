import 'package:flutter/material.dart';
import 'package:login_app_2/screens/payment.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:login_app_2/service/api_service.dart'; 

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  String? qrCode;
  String? errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> _scanQRCode() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      await Permission.camera.request();
      status = await Permission.camera.status; 
    }

    if (status.isGranted) {
      try {
        var result = await BarcodeScanner.scan();
        setState(() {
          qrCode = result.rawContent;
          errorMessage = null;
        });
        if (qrCode != null) {
          await _sendQRCodeToAPI(qrCode!);
        }
      } catch (e) {
        setState(() => errorMessage = 'Quét mã QR thất bại');
      }
    } else {
      setState(() => errorMessage = 'Cần quyền truy cập camera để quét mã QR.');
    }
  }
  
  Future<void> _sendQRCodeToAPI(String qrCode) async {
    try {
      final jsonResponse = await _apiService.sendQRCode(qrCode, showLoading: (showLoading) {}); 

      if (jsonResponse['success']) {
        String userName = jsonResponse['userName'] ?? 'N/A';
        String taxId = jsonResponse['taxId'] ?? 'N/A';
        String referenceId = jsonResponse['referenceId'] ?? 'N/A';
        double totalAmount = jsonResponse['totalAmount'] != null
            ? double.tryParse(jsonResponse['totalAmount'].toString()) ?? 0.0
            : 0.0;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              userName: userName,
              taxId: taxId,
              referenceId: referenceId,
              totalAmount: totalAmount,
            ),
          ),
        );
      } else {
        String errorMsg = jsonResponse['message'] ?? 'Không thể xử lý mã QR. Vui lòng thử lại.';
        _showErrorDialog('Lỗi', errorMsg);
      }
    } catch (e) {
      _showErrorDialog('Lỗi', e.toString());
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

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        String? qrCodeResult = await QrCodeToolsPlugin.decodeFrom(pickedFile.path);

        if (qrCodeResult != null && qrCodeResult.isNotEmpty) {
          setState(() {
            qrCode = qrCodeResult;
            errorMessage = null;
          });
          await _sendQRCodeToAPI(qrCode!);
        } else {
          setState(() => errorMessage = 'Không tìm thấy mã QR trong ảnh.');
        }
      } catch (e) {
        setState(() => errorMessage = 'Có lỗi xảy ra khi xử lý ảnh: $e');
      }
    } else {
      setState(() => errorMessage = 'Chưa chọn ảnh.');
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() => qrCode = scanData.code);

      if (qrCode != null) {
        await _sendQRCodeToAPI(qrCode!);
      }
    });
  }

  void _toggleFlash() { 
    setState(() {
      isFlashOn = !isFlashOn;
      controller?.toggleFlash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét QR-Code'),
        backgroundColor: const Color.fromARGB(255, 155, 0, 0),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ), 
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(3.1416),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 250,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Vui lòng cho mã vào khung hình, quy trình quét mã sẽ diễn ra tự động',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              size: 40,
              color: const Color.fromARGB(255, 155, 0, 0),
            ),
            onPressed: _toggleFlash,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _uploadImage,
            icon: const Icon(Icons.image_outlined),
            label: const Text('Tải ảnh lên'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          if (qrCode != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Quét mã QR: $qrCode'),
            ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ), 
    );
  }
}
