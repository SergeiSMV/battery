



import 'package:flutter/material.dart';

import '../../../../../static/ui/colors.dart';



class SelectedOrderAppBar{
  const SelectedOrderAppBar();

  appBar(String num){
    return AppBar(
      centerTitle: false,
      iconTheme: IconThemeData(color: firmColor),
      automaticallyImplyLeading: true,
      elevation: 2.0,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('заявка №$num', style: TextStyle(fontSize: 16, color: firmColor),),
          const Text('склада сырья и материалов', style: TextStyle(fontSize: 12, color: Colors.grey),),
        ],
      ),
    );
  }
}