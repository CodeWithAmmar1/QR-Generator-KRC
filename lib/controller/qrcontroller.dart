import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

class QRGeneratorController extends GetxController {
  var ssid = "".obs;
  var password = "".obs;
  var isHidden = false.obs;
  final ScreenshotController screenshotController = ScreenshotController();
  var widthInches = 3.15.obs; 

  String _escape(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll(':', '\\:');
  }

  String get qrData {
    if (ssid.value.isEmpty) return "";
    String encryption = "WPA";
    String escapedSsid = _escape(ssid.value);
    String escapedPass = _escape(password.value);
    String hidden = isHidden.value ? "true" : "false";
    return "WIFI:T:$encryption;S:$escapedSsid;P:$escapedPass;H:$hidden;;";
  }

  Future<void> downloadQR(double requestedWidthInches) async {
    try {
      double targetWidth = requestedWidthInches * 96;
      final imageBytes = await screenshotController.captureFromWidget(
        Material(
          color: Colors.transparent,
          child: _buildHiddenFrameForDownload(targetWidth),
        ),
        pixelRatio: 1.0,
        delay: const Duration(milliseconds: 200),
      );

      if (imageBytes != null) {
        final blob = html.Blob([imageBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
            html.AnchorElement(href: url)
              ..setAttribute("download", "${ssid.value}.png")
              ..style.display = 'none';

        html.document.body?.append(anchor);
        anchor.click();
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      }
    } catch (e) {
      log("Download error: $e");
    }
  }

  Widget _buildHiddenFrameForDownload(double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          padding: EdgeInsets.all(width * 0.06),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black, width: width * 0.04),
              left: BorderSide(color: Colors.black, width: width * 0.04),
              right: BorderSide(color: Colors.black, width: width * 0.04),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(width * 0.08),
              topRight: Radius.circular(width * 0.08),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: width * 0.75,
                errorCorrectionLevel:
                    QrErrorCorrectLevel.H, // Mandatory for logo overlay
              ),
              Container(
                width: width * 0.2,
                height: width * 0.2,
                color: Colors.white,
                child: Image.asset('assets/logo.png', fit: BoxFit.contain),
              ),
            ],
          ),
        ),
        Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: width * 0.03),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(width * 0.06),
              bottomRight: Radius.circular(width * 0.06),
            ),
          ),
          child: Center(
            child: Text(
              ssid.value.isEmpty ? "SCAN ME" : ssid.value.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
