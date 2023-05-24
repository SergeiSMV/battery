import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'colors.dart';

noAccesse(){
  return Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Нет доступных разделов.', style: TextStyle(color: firmColor),),
      Text('Обратитесь к Вашему руководителю или администратору.', style: TextStyle(color: firmColor), textAlign: TextAlign.center,),
      SizedBox(height: 150, width: 150, child: Lottie.asset('lib/images/lottie/empty.json')),
      ],
    )
  );
}