import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'sources/accounts/ui/login/greeting.dart';
import 'sources/accounts/ui/login/login.dart';
import 'static/models/bloc/accesses_bloc.dart';
import 'static/models/current_device_id.dart';


void main() async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ru');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    currentDeviceID().then((value) => runApp(RazApp(currentDeviceID: value)));
  });
}


class RazApp extends StatelessWidget {
  final String currentDeviceID;
  final storageDeviceId = GetStorage().read('deviceId');
  RazApp({Key? key, required this.currentDeviceID}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
        BlocProvider<AccessesBloc>(create: (context) => AccessesBloc()),
      ], 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white.withOpacity(0),
              statusBarIconBrightness: Brightness.dark
            ),
          ),
        ),
        home: currentDeviceID == storageDeviceId ? Greeting() : const Login()
      ), 
    );
  }
}
