


import 'package:flutter/material.dart';

import '../../../../../../static/ui/colors.dart';
import '../../models/item_constructor.dart';

Widget itemCard(BuildContext itemInfoContext, Map itemData, bool isExpanded){
  TextStyle style = TextStyle(fontSize: 12, color: firmColor);
  TextAlign align = TextAlign.left;
  double width = MediaQuery.of(itemInfoContext).size.width * 0.8;
  ItemConstructor item = ItemConstructor(itemData: itemData);

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      isExpanded ? const SizedBox.shrink() :
      const Divider(color: Colors.white, indent: 37, endIndent: 37, height: 30, thickness: 1,),

      SizedBox(
        width: width,
        child: Text(item.fullName, style: TextStyle(fontFamily: 'Montserrat-Regular', fontSize: 18, color: item.status == 'в работе' ? firmColor : Colors.red), 
          textAlign: align,
        )
      ),

      SizedBox(
        width: width,
        child: Text('статус: ${item.status}', style: TextStyle(fontSize: 14, color: firmColor), textAlign: align,)
      ),

      SizedBox(
        width: width,
        child: Text('паллет: ${item.size == 'big' ? 'большой' : 'стандартный'}', style: TextStyle(fontSize: 14, color: firmColor), textAlign: align,)
      ),
      
      const SizedBox(height: 10),

      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: width, child: Text('место хранения: ${item.place} | ячейка: ${item.cell}', style: style, textAlign: align)),
          SizedBox(width: width, child: Text('поставщик: ${item.producer}', style: style, textAlign: align)),
          SizedBox(width: width, child: Text('дата поставки: ${item.fifo}', style: style, textAlign: align)),
          SizedBox(width: width, child: Text('количество на остатке: ${item.quantity} ${item.unit}', style: style, textAlign: align)),
          SizedBox(width: width, child: Text('в резерве: ${item.reserve} ${item.unit}', style: style, textAlign: align)),
          SizedBox(width: width, child: Text('принял: ${item.author}', style: style, textAlign: align)),
        ],
      ),
    ],
  );
}