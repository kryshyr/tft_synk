import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceID() async {
  // create instance of DeviceInfoPlugin
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // checking platform type
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? 'Unknown ID';
  } else {
    return 'Unsupported platform';
  }
}
