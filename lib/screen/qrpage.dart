import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrapp/controller/qrcontroller.dart';
import 'package:screenshot/screenshot.dart';

class Qrpage extends StatelessWidget {
  Qrpage({super.key});
  final controller = Get.put(QRGeneratorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "BITA HOMES WiFi QR Code",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff082A5C),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildInputLabel("Network Name (SSID)"),
                  TextField(
                    onChanged: (val) => controller.ssid.value = val,
                    decoration: _inputDecoration("Enter SSID"),
                  ),

                  Obx(
                    () => Row(
                      children: [
                        Checkbox(
                          value: controller.isHidden.value,
                          activeColor: const Color(0xff082A5C),
                          onChanged: (val) => controller.isHidden.value = val!,
                        ),
                        const Text(
                          "Hidden Network?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildInputLabel("Password"),
                  TextField(
                    obscureText: false,
                    onChanged: (val) => controller.password.value = val,
                    decoration: _inputDecoration("Enter Password"),
                  ),
                  const SizedBox(height: 20),
                  _buildInputLabel("Encryption"),
                  const Text(
                    "Locked to WPA/WPA2",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  const Text(
                    "Power By Kazmah Regional Company",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Developed By Muhammad Ali Ammar",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Obx(
                  () => _buildQRFrame(controller.ssid.value, controller.qrData),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRFrame(String ssidName, String data) {
    if (data.isEmpty) return const Text("Enter SSID to generate");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wrap ONLY the part you want to be in the final image
        Screenshot(
          controller: controller.screenshotController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QrImageView(
                      data: data,
                      version: QrVersions.auto,
                      size: 200.0,
                      gapless: true,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 236,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  ssidName.isEmpty ? "SCAN ME" : ssidName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),

        // DOWNLOAD BUTTON
        ElevatedButton.icon(
          onPressed: () => controller.downloadQR(),
          icon: const Icon(Icons.download_rounded),
          label: const Text("Download PNG"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff082A5C),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xff082A5C),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
