import 'package:flutter/material.dart';

import '../../../../../../static/ui/colors.dart';

description(){
  String funcDescription = 'Внимание! Приемка ведется общим количеством, при условии '
  'идентичности паллетов по количеству ТМЦ на паллете и количеству тары в ряду. '
  'Дальнейшее распределение осуществляется из "Склад ВК".';

  return Padding(
    padding: const EdgeInsets.only(left: 0, right: 0),
    child: Container(
      decoration: BoxDecoration(color: mainColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 15, top: 8, bottom: 8),
        child: Text(funcDescription, textAlign: TextAlign.left, style: const TextStyle(color: Colors.white, fontSize: 12),),
      )
    ),
  );
}