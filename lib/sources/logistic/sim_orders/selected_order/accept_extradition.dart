import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../../static/ui/colors.dart';
import '../../../../static/api/api_routers.dart';
import '../../../../static/api/connection.dart';


acceptExtradition(BuildContext soContext, Map item){
  return showDialog(
    context: soContext,
    builder: (context) {

      var userData = GetStorage().read('info');
      String author = '${userData['surname']} ${userData['name'][0]}.${userData['patronymic'][0]}.';

      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text('Принять ${item['category']} ${item['name']} ${item['color']}', textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 14, fontFamily: 'Montserrat')),
            Text('в количестве ${item['fact_quant']} ${item['unit']}?', textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 14, fontFamily: 'Montserrat')),
            const SizedBox(height: 10),
            Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(onPressed: (){
                  Map acceptData = {'data': item, 'author': author};
                  Connection(data: acceptData, route: simAcceptExtradition).connect();
                  Navigator.pop(context);
                }, child: Text('принять', textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 12, fontFamily: 'Montserrat'))),
                const SizedBox(width: 10),
                TextButton(onPressed: (){ Navigator.pop(context); }, child: Text('отмена', textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 12, fontFamily: 'Montserrat')))
              ],
            )),
          ],
        ),
      );
    });
}