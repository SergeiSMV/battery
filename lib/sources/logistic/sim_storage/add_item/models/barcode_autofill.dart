import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/api/api_routers.dart';
import '../../../../../static/api/connection.dart';
import '../../../../../static/ui/system_message.dart';
import '../bloc/additem_bloc.dart';



barcodeAutoFill(BuildContext parrentContext, String barcode, Map currentState, List controllers) async {
  Connection(data: {'barcode': barcode}, route: simGetBarcodeItem).connect().then((value) 
    {
      value == 'empty' ? 
      {
        currentState['barcode'] = barcode.toString(),
        currentState['category'] = '',
        currentState['name'] = '',
        currentState['color'] = '',
        currentState['producer'] = '',
        currentState['unit'] = '',
        currentState['box_size'] = '0x0x0',
        currentState['base_box_size'] = '',
        currentState['pallet_row'] = '0',
        currentState['pallet_quantity'] = '0',
        currentState['quantity'] = '0',
        for (var n in controllers){ n.clear() },
        parrentContext.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))),
        systemMessage(parrentContext, 'ничего не найдено', 'lib/images/lottie/close.json'),
      }
      :
      {
        currentState['category'] = value['category'].toString(),
        currentState['name'] = value['name'].toString(),
        currentState['color'] = value['color'].toString(),
        currentState['producer'] = value['producer'].toString(),
        currentState['unit'] = value['unit'].toString(),
        currentState['barcode'] = '',
        currentState['box_size'] = '0x0x0',
        currentState['base_box_size'] = '',
        currentState['pallet_row'] = '0',
        currentState['pallet_quantity'] = '0',
        currentState['quantity'] = '0',
        for (var n in controllers){ n.clear() },
        parrentContext.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))),
      };
    }
  );
}