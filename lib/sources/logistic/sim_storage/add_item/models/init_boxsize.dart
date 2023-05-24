import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/api/api_routers.dart';
import '../../../../../static/api/connection.dart';
import '../bloc/additem_bloc.dart';

initBoxSize(BuildContext context, Map currentState){
  if(currentState['producer'].toString().isEmpty){
    null;
  } else {
    if(currentState['base_box_size'].toString().isEmpty){
      Connection(data: {'category': currentState['category'], 'name': currentState['name'], 'producer': currentState['producer']}, route: simNmBoxSize).connect().then((value){
        value is Map ?
          { 
            currentState['base_box_size'] = value['box_size'].toString(),
            currentState['base_box_quantity'] = value['box_quantity'].toString(),
            context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))) 
          }
          : null; 
      });
    } else { null; }
  }
}