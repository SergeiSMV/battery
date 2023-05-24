import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

Future<String> currentDeviceID() async {
  String? deviceId;
  var deviceInfo = DeviceInfoPlugin();
    try {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id.toString();
      return deviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId';
      return deviceId;
    }
}