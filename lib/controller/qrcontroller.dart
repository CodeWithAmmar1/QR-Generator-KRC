import 'dart:developer';

import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

class QRGeneratorController extends GetxController {
  var ssid = "".obs;
  var password = "".obs;
  var isHidden = false.obs;
  final ScreenshotController screenshotController = ScreenshotController();

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

Future<void> downloadQR() async {
  try {
    final imageBytes = await screenshotController.capture();
    
    if (imageBytes != null) {
      final blob = html.Blob([imageBytes], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
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
  
}
