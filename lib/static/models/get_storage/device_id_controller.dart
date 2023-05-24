import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';


class DeviceIdController extends GetxController {
  final deviceID = GetStorage();
  String get deviceId => deviceID.read('deviceId') ?? 'Empty';
  void writeDeviceId(String? id) => deviceID.write('deviceId', id);
  void clearDeviceId() => deviceID.remove('deviceId');
}