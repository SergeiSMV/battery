import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../../../../static/api/api_routers.dart';
import '../../../../static/api/connection.dart';
import '../../../../static/models/bloc/accesses_bloc.dart';
import '../../../../static/ui/colors.dart';
import '../../../home/ui/home.dart';


// страница приветствия

class Greeting extends StatelessWidget {
  Greeting({Key? key}) : super(key: key);

  final userInfo = GetStorage().read('info');
  final String userID = GetStorage().read('info')['id'].toString();

  @override
  Widget build(BuildContext context) {
    Connection(data: {'user_id': userID}, route: indexAccessRoute).connect();
    context.read<AccessesBloc>().add(GetAccessesEvent());
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200, width: 200, child: Lottie.asset('lib/images/lottie/greeting.json')),
              const SizedBox(height: 30),
              Text('Здравствуйте,', style: TextStyle(fontSize: 18, color: firmColor)),
              Text('${userInfo['name']} ${userInfo['patronymic']}!', style: TextStyle(fontSize: 18, color: firmColor)),
            ],
          ),
        ),
        nextScreen: const Home(),
        backgroundColor: Colors.white,
        duration: 3000,
        splashIconSize: 2000,
      ),
    );
  }
}