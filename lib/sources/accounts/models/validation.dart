import 'package:battery/static/ui/system_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../static/api/api_routers.dart';
import '../../../static/api/connection.dart';
import '../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../static/models/current_device_id.dart';
import '../../../static/models/get_storage/account_controller.dart';
import '../../../static/models/get_storage/device_id_controller.dart';
import '../../../static/models/unlogin.dart';
import '../ui/login/greeting.dart';
import 'bloc/identifier_bloc.dart';
import 'bloc/password_bloc.dart';



class Validation{
  final BuildContext context;
  final String login;
  final String password;
  final bool autoLogin;
  Validation({required this.context, required this.autoLogin, required this.login, required this.password});


  request() async {
    final deviceController = Get.put<DeviceIdController>(DeviceIdController());
    var userController = Get.put<AccountController>(AccountController());
    Connection server = Connection(data: {'login': login, 'password': password}, route: validation);
    server.connect().then((value) {
      if(value == 'disconnected'){
        systemMessage(context, 'сервер не доступен', 'lib/images/lottie/close.json');
        Future.delayed(const Duration(seconds: 3)).then((value) {
          context.read<IsTappedBloc>().add(IsTappedChangeEvent()); 
        });

      } else if(value == 0){
        systemMessage(context, 'не верный идентификатор или пароль', 'lib/images/lottie/close.json');
        Future.delayed(const Duration(seconds: 3)).then((value) {
          context.read<IsTappedBloc>().add(IsTappedChangeEvent()); 
        });

      } else if(value == 1) {
        autoLogin ? currentDeviceID().then((value) => deviceController.writeDeviceId(value)) : null;
        Connection server = Connection(data: {'login': login, 'password': password}, route: userInfoRoute);
        server.connect().then((value) { 
          value is Map<String, dynamic> ? 
          {
            userController.writeUserInfo(value),
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Greeting()))
          } 
          : 
          { 
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString()), duration: const Duration(seconds: 20),)),
            unlogin(context)
          };
        });

      } else {
        Future.delayed(const Duration(seconds: 3)).then((value) {
          context.read<IsTappedBloc>().add(IsTappedChangeEvent()); 
        });
        context.read<IdentifierBloc>().add(const IdentifierChangeEvent(data: '')); 
        context.read<PasswordBloc>().add(const PasswordChangeEvent(data: ''));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString()), duration: const Duration(seconds: 20),));
      }
    });
  }
}