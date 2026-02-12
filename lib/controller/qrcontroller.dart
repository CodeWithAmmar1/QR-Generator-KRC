import 'package:get/get.dart';

class QRGeneratorController extends GetxController {
  var ssid = "".obs;
  var password = "".obs;
  var isHidden = false.obs; // Added for hidden networks

  // 1. Helper function to escape special characters (\ ; , : )
  String _escape(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll(':', '\\:');
  }

  // 2. Updated Format: WIFI:T:WPA;S:ssid;P:password;H:true;;
  String get qrData {
    if (ssid.value.isEmpty) return "";
    
    String encryption = "WPA"; // This covers both WPA and WPA2
    String escapedSsid = _escape(ssid.value);
    String escapedPass = _escape(password.value);
    String hidden = isHidden.value ? "true" : "false";

    return "WIFI:T:$encryption;S:$escapedSsid;P:$escapedPass;H:$hidden;;";
  }
}