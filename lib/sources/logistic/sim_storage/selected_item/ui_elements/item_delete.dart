import 'package:flutter/material.dart';

import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';




itemDelete(Map itemData, BuildContext itemMenuRouterContext){
  return Builder(
    builder: (context) {
      return Container(decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)), color: Colors.red),
        height: 35,
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextButton(
          onPressed: () {
            _chItemDelete(context, itemData['reserve'], itemData);
          }, child: const Text('удалить позицию', style: TextStyle(color: Colors.white),))
      );
    }
  );
}

_chItemDelete(BuildContext itemDeleteContext, int reserve, Map deleteData){
  return reserve == 0 ? {
    Connection(data: deleteData, route: simDeleteItem).connect(),
    Navigator.pop(itemDeleteContext)
  } :
  systemMessage(itemDeleteContext, 'Позиция находится в резерве! Удаление невозможно!', 'lib/images/lottie/close.json');
}