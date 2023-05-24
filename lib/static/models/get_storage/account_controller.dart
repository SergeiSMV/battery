import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';


class AccountController extends GetxController {
  var account = GetStorage();
  Map<String, dynamic> get userInfo => account.read('info') ?? {};
  void writeUserInfo(Map<String, dynamic> userInfo) => account.write('info', userInfo);
  void clearUserInfo() => account.remove('info');
}