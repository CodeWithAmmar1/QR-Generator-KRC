import 'package:get/get.dart';

class QRGeneratorController extends GetxController {
  var ssid = "".obs;
  var password = "".obs;
  String get qrData => "WIFI:S:${ssid.value};T:WPA;P:${password.value};;";
}
