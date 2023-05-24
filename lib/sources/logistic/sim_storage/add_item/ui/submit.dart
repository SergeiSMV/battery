import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../models/items_exceptions.dart';

submit(BuildContext context, Map currentState){
  return Padding(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        color: Colors.blue.shade400,
      ),
      height: 35,
      child: TextButton(onPressed: () async {
        ProgressHUD.of(context)?.showWithText('поступление');
        currentState['exceptions'] = itemsExceptions;
        await Connection(data: currentState, route: addItem).connect().then((value){
          ProgressHUD.of(context)?.dismiss();
          value == 'done' ? Navigator.pop(context) : 
          systemMessage(context, value, 'lib/images/lottie/close.json');
        });
      }, child: const Text('сохранить', style: TextStyle(color: Colors.white),))
    ),
  );
}