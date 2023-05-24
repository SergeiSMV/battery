import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../../../../../static/ui/colors.dart';
import '../../../../../../static/ui/system_message.dart';
import '../bloc/places_bloc.dart';
import '../values/additem_cell.dart';
import '../values/additem_place.dart';
import '../models/item_element.dart';

placeOptions(BuildContext context, Map currentState){
  Map places = context.watch<PlacesBloc>().state;
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 13,),
          Container(
            decoration: BoxDecoration(color: mainColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(3)),
            child: const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
              child: Text('Параметры размещения', style: TextStyle(fontSize: 12, color: Colors.white),),
            )
          ),
          Expanded(child: Divider(color: Colors.grey.shade700, indent: 5, endIndent: 30,)),
        ],
      ),

      itemElement('склад:', currentState['place'].toString(), 'укажите склад размещения', () => {
        ProgressHUD.of(context)?.showWithText('ищем склады'),
        AddItemPlace(parrentContext: context, currentState: currentState).getPlaces()
        }
      ),
      
      itemElement('ячейка:', currentState['cell'].toString(), 'укажите ячейку размещения', (){
        places[currentState['place'].toString()] == null ? systemMessage(context, 'укажите склад', 'lib/images/lottie/close.json') : 
        AddItemCell(parrentContext: context, cells: places[currentState['place'].toString()], currentState: currentState).setCell(); 
      }) 
    ],
  );
}