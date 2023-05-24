import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../sim_storage/models/sim_elements.dart';
import '../../sim_add_order/sim_add_order.dart';





simOrdersMenu(BuildContext context, List accesses){
  Color iconColor = Colors.white;
  SimElements simElements = SimElements(blocState: accesses);
  
  List elements = [
    // // скрыть выполненные заявки
    // IconButton(onPressed: (){ 
    //   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddItem()));
    // }, icon: Icon(MdiIcons.noteCheckOutline, size: 25, color: iconColor,), splashRadius: 0.1,),
  ];

  // кнопка добавления заявки
  simElements.soAdd() ? elements.add(
    IconButton(onPressed: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SimAddOrder()));
    }, icon: Icon(MdiIcons.plusCircle, size: 25, color: iconColor,), splashRadius: 0.1,)
  ) : null;
 
  return Padding(
    padding: const EdgeInsets.only(left: 17),
    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [...elements]),
  );

}