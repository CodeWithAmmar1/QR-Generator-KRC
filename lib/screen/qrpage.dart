import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrapp/controller/qrcontroller.dart';

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
                    "WiFi QR Code",
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
                    decoration: _inputDecoration("e.g. MyHomeWiFi"),
                  ),
                  const SizedBox(height: 20),
                  _buildInputLabel("Password"),
                  TextField(
                    obscureText: true,
                    onChanged: (val) => controller.password.value = val,
                    decoration: _inputDecoration("********"),
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
                ],
              ),
            ),
          ),

          // RIGHT SIDE: QR PREVIEW
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: QrImageView(data: data, version: QrVersions.auto, size: 200.0),
        ),
        Container(
          width: 228, 
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Text(
            ssidName.isEmpty ? "SET SSID" : ssidName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
