
import 'package:flutter/material.dart';

import '../../../../../static/ui/colors.dart';



class ColorsAppBar{
  const ColorsAppBar();

  appBar(){
    return AppBar(
      centerTitle: false,
      iconTheme: IconThemeData(color: firmColor),
      automaticallyImplyLeading: true,
      elevation: 2.0,
      backgroundColor: Colors.white,
      title: Text('цвета СиМ', style: TextStyle(fontSize: 16, color: firmColor),),
    );
  }
}