import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/additem_bloc.dart';
import '../models/enter_value.dart';

boxInfo(BuildContext context, Map currentState, TextEditingController heightCntrlr, TextEditingController widthCntrlr, TextEditingController lengthCntrlr, TextEditingController boxQuantityCntrl){
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text('укажите параметры тары:\nвысота, ширина, длина (мм):', style: TextStyle(fontSize: 12, color: Colors.red),),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: enterValue('в:', '0', TextInputType.number, heightCntrlr, (value) { 
                String height = value.toString();
                String width = currentState['box_size'].split('x')[1];
                String length = currentState['box_size'].split('x')[2];
                currentState['box_size'] = '${height}x${width}x$length';
                context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))); 
              },),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: enterValue('ш:', '0', TextInputType.number, widthCntrlr, (value) {
                String height = currentState['box_size'].split('x')[0];
                String width = value.toString();
                String length = currentState['box_size'].split('x')[2];
                currentState['box_size'] = '${height}x${width}x$length';
                context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))); 
              },),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: enterValue('д:', '0', TextInputType.number, lengthCntrlr, (value) {
                String height = currentState['box_size'].split('x')[0];
                String width = currentState['box_size'].split('x')[1];
                String length = value.toString();
                currentState['box_size'] = '${height}x${width}x$length';
                context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))); 
              },),
            ),
          ],
        ),
      ),
      enterValue('количество ТМЦ в таре (${currentState['unit'].toString()}):', '0', TextInputType.number,
        boxQuantityCntrl,
        (value) { currentState['box_quantity'] = value; context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))); },),
    ],
  );
}