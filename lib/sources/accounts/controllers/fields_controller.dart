import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../static/ui/system_message.dart';
import '../models/bloc/autologin_bloc.dart';
import '../models/bloc/identifier_bloc.dart';
import '../models/bloc/password_bloc.dart';
import '../models/validation.dart';




fieldsController(BuildContext context){
  String login = context.read<IdentifierBloc>().state;
  String password = context.read<PasswordBloc>().state;
  bool autoLogin = context.read<AutoLoginBloc>().state;

  void clearState() => context.read<IdentifierBloc>().add(const IdentifierChangeEvent(data: '')); context.read<PasswordBloc>().add(const PasswordChangeEvent(data: ''));

  if(login.isEmpty || password.isEmpty){
    clearState();
    systemMessage(context, 'заполнены не все поля', 'lib/images/lottie/close.json');
    Future.delayed(const Duration(seconds: 3)).then((value) {
      context.read<IsTappedBloc>().add(IsTappedChangeEvent()); 
    });
  } else {
    clearState();
    Validation(context: context, login: login, password: password, autoLogin: autoLogin).request();
  }
}