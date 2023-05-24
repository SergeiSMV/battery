import 'package:get_storage/get_storage.dart';

class AccountData{
  String userId = GetStorage().read('info')['id'].toString();
  String surname = GetStorage().read('info')['surname'];
  String name = GetStorage().read('info')['name'];
  String patronymic = GetStorage().read('info')['patronymic'];
  String department = GetStorage().read('info')['department'];
  String position = GetStorage().read('info')['position'];
  String login = GetStorage().read('info')['login'];
  String password = GetStorage().read('info')['password'];
}