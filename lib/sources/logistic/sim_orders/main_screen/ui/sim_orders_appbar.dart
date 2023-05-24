
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../static/ui/colors.dart';


class SimOrdersAppbar{
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SimOrdersAppbar({required this.scaffoldKey});

  appBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 2.0,
      backgroundColor: Colors.green.shade100,
      title: Row(
        children: [
          IconButton(onPressed: () => scaffoldKey.currentState!.openDrawer(), icon: Icon(MdiIcons.menu, size: 25, color: firmColor,), splashRadius: 0.1,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('заявки склада сырья и материалов', style: TextStyle(fontSize: 15, color: firmColor),),
                Text('департамент логистики', style: TextStyle(fontSize: 10, color: firmColor),),
              ],
            ),
          )
        ],
      )
    );
  }
}