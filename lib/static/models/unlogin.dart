import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../sources/accounts/ui/login/login.dart';
import 'get_storage/account_controller.dart';
import 'get_storage/device_id_controller.dart';


unlogin(BuildContext context){
  Get.put<DeviceIdController>(DeviceIdController()).clearDeviceId();
  Get.put<AccountController>(AccountController()).clearUserInfo();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
}