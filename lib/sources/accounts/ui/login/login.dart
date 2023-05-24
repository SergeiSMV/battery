import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../../static/ui/colors.dart';
import '../../controllers/fields_controller.dart';
import '../../models/bloc/autologin_bloc.dart';
import '../../models/checkbox_color.dart';
import '../../models/bloc/identifier_bloc.dart';
import '../../models/bloc/password_bloc.dart';
import 'license.dart';


class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IdentifierBloc>(create: (context) => IdentifierBloc()),
        BlocProvider<PasswordBloc>(create: (context) => PasswordBloc()),
        BlocProvider<AutoLoginBloc>(create: (context) => AutoLoginBloc()),
        BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc()),
      ], 
      child: Builder(
        builder: (context){
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white.withOpacity(0), statusBarIconBrightness: Brightness.dark));
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('lib/images/tunglogo.png', scale: 7.0,),

                    const SizedBox(height: 20),
                    _input(const Icon(Icons.person), 'идентификатор', (value) {context.read<IdentifierBloc>().add(IdentifierChangeEvent(data: value));}, false),

                    const SizedBox(height: 10),
                    _input(const Icon(Icons.lock), 'пароль', (value) {context.read<PasswordBloc>().add(PasswordChangeEvent(data: value));}, true),
                    
                    const SizedBox(height: 20),
                    BlocBuilder<IsTappedBloc, bool>(
                      builder: (context, state){
                        return state == false ? _enterButton(context) : Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,));
                      }
                    ),

                    _checkbox(context),

                    const SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(child: license),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }


  _input(Icon icon, String hint, change, bool visibility) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: SizedBox(
        height: 35,
        width: 310,
        child: TextField(
          style: TextStyle(fontSize: 18, color: firmColor),
          minLines: 1,
          obscureText: visibility,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontFamily: 'Montserrat'),
            hintText: hint,
            prefixIcon: IconTheme(data: const IconThemeData(color: Color(0xFF78909C)), child: icon),
            isCollapsed: true),
          onChanged: (value) { change(value); },
        ),
      ),
    );
  }

  _enterButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: TextButton(
        child: Center(
          child: Container(
            height: 35,
            decoration: BoxDecoration(color: const Color(0xFFff8c00), borderRadius: BorderRadius.circular(5)), 
            child: const Center(child: Text('вход', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),))
          ),
        ),
        onPressed: (){
          FocusScope.of(context).unfocus();
          context.read<IsTappedBloc>().add(IsTappedChangeEvent()); 
          fieldsController(context);
        }, 
      ),
    );
  }

  _checkbox(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AutoLoginBloc>(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<AutoLoginBloc, bool>(
            builder: (context, state) {
              return Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(checkBoxColor),
                  value: state,
                  onChanged: (bool? value) { context.read<AutoLoginBloc>().add(AutoLoginChangeEvent(data: value!));}
                ),
              );
            },
          ),
          Text('сохранить данные логин / пароль', style: TextStyle(fontSize: 12, fontFamily: 'Montserrat', color: firmColor))
        ],
      ),
    );
  }

}