import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../static/ui/colors.dart';
import '../bloc/additem_bloc.dart';
import '../models/items_exceptions.dart';
import 'box_info.dart';
import '../models/enter_value.dart';

quantityOptions(BuildContext context, Map currentState, List controllers){

  TextEditingController heightCntrlr = controllers[0];
  TextEditingController widthCntrlr = controllers[1];
  TextEditingController lengthCntrlr = controllers[2];
  TextEditingController boxQuantityCntrl = controllers[3];
  TextEditingController rowQuantityCntrlr = controllers[4];
  TextEditingController palletQuantityCntrlr = controllers[5];
  TextEditingController totalQuantityCntrlr = controllers[6];

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
              child: Text('Количество', style: TextStyle(fontSize: 12, color: Colors.white),),
            )
          ),
          Expanded(child: Divider(color: Colors.grey.shade700, indent: 5, endIndent: 30,)),
        ],
      ),
        
        
      itemsExceptions.contains(currentState['category'].toString().toLowerCase()) ? 
        const SizedBox.shrink() :
        currentState['producer'].toString().isEmpty ? 
          const SizedBox.shrink() : 
          currentState['base_box_size'].toString() == '0x0x0' ? 
            const SizedBox(height: 15) : 
            const SizedBox.shrink(),
        
      itemsExceptions.contains(currentState['category'].toString().toLowerCase()) ? 
        const SizedBox.shrink() :
        currentState['producer'].toString().isEmpty ? 
          const SizedBox.shrink() : 
          currentState['base_box_size'].toString() == '0x0x0' ?  
            boxInfo(context, currentState, heightCntrlr, widthCntrlr, lengthCntrlr, boxQuantityCntrl) : 
            const SizedBox.shrink(),
        
      itemsExceptions.contains(currentState['category'].toString().toLowerCase()) ? const SizedBox.shrink() :
      enterValue('количество тары в ряду:', '0', TextInputType.number, rowQuantityCntrlr,
        (value) { 
          currentState['pallet_row'] = value; context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))); 
        },),
        
      enterValue('количество ТМЦ на паллете (${currentState['unit'].toString()}):', '0', TextInputType.number,
        palletQuantityCntrlr,
        (value) { 
          currentState['pallet_quantity'] = value; 
          currentState['place'] = '';
          currentState['cell'] = '';
          context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))); 
        },),
        
      enterValue('общее количество ТМЦ (${currentState['unit'].toString()}):', '0', TextInputType.number, 
        totalQuantityCntrlr,
        (value) {
          currentState['quantity'] = value;
          currentState['place'] = '';
          currentState['cell'] = '';
          context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))); 
        },),
    ],
  );
}