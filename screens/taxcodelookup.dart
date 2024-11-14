import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app_2/screens/home.dart';

class TaxCodeLookUpScreen extends StatefulWidget {
  const TaxCodeLookUpScreen({super.key});

  @override
  _TaxCodeLookupScreenState createState() => _TaxCodeLookupScreenState();
}

class _TaxCodeLookupScreenState extends State<TaxCodeLookUpScreen> {
  final _documentTypeController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _captchaController = TextEditingController();
  String? taxCodeResult;
  String? taxpayerName;
  bool isLoading = false;
  String generatedCaptcha = '';

  @override
  void initState() {
    super.initState();
    _generateCaptcha(); 
  }

  void _generateCaptcha() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random rnd = Random();
    generatedCaptcha = String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    setState(() {});
  }

  Future<void> _lookupTaxCode() async {
    if (_captchaController.text != generatedCaptcha) {
      setState(() {
        taxCodeResult = 'Mã kiểm tra không đúng';
        taxpayerName = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      taxCodeResult = null;
      taxpayerName = null;
    });

    final documentType = _documentTypeController.text;
    final documentNumber = _documentNumberController.text;
    final captcha = _captchaController.text;

    final url = Uri.parse('https://daotaothuedientu.gdt.gov.vn/ICanhanMobile2/api/lookupTinGip');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'document_type': documentType,
          'document_number': documentNumber,
          'captcha': captcha,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          taxCodeResult = data['tax_code'];
          taxpayerName = data['taxpayer_name'];
        });
      } else {
        setState(() {
          taxCodeResult = 'Không tìm thấy kết quả';
          taxpayerName = null;
        });
      }
    } catch (e) {
      setState(() {
        taxCodeResult = 'Lỗi kết nối. Vui lòng thử lại.';
        taxpayerName = null;
      });
    } finally {
      setState(() {
        isLoading = false;
        _generateCaptcha(); 
      });
    }
  }

  @override
  void dispose() {
    _documentTypeController.dispose();
    _documentNumberController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(1000, 155, 0, 0),
        title: const Text("Tra cứu mã số thuế"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Loại giấy tờ",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "cccd", child: Text("Căn cước công dân")),
                DropdownMenuItem(value: "cmnd", child: Text("Chứng minh nhân dân")),
              ],
              onChanged: (value) {
                _documentTypeController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _documentNumberController,
              decoration: const InputDecoration(
                labelText: "Số giấy tờ",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _captchaController,
                    decoration: const InputDecoration(
                      labelText: "Mã kiểm tra",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 80,
                  height: 50,
                  color: Colors.grey[300],
                  child: Center(
                    child: Text(
                      generatedCaptcha,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _generateCaptcha,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black12,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: isLoading ? null : _lookupTaxCode,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Tra cứu", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 24),
            if (taxCodeResult != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mã số thuế",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      taxCodeResult!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    if (taxpayerName != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        "Tên người nộp thuế: $taxpayerName",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
