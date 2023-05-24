
import 'package:flutter/material.dart';

import '../../../../../static/ui/colors.dart';



class SimAddOrderAppBar{
  const SimAddOrderAppBar();

  appBar(){
    return AppBar(
      centerTitle: false,
      iconTheme: IconThemeData(color: firmColor),
      automaticallyImplyLeading: true,
      elevation: 2.0,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('новая заявка', style: TextStyle(fontSize: 16, color: firmColor),),
          const Text('склад сырья и материалов', style: TextStyle(fontSize: 12, color: Colors.grey),),
        ],
      ),
    );
  }
}