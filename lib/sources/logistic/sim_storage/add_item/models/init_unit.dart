import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/api/api_routers.dart';
import '../../../../../static/api/connection.dart';
import '../bloc/additem_bloc.dart';

initUnit(BuildContext context, Map currentState){
  if(currentState['unit'] == ''){
    if(currentState['category'] == '' || currentState['name'] == '' || currentState['producer'] == ''){
      null;
    }
    else {
      Connection(data: {'category': currentState['category'], 'name': currentState['name'], 'producer': currentState['producer']}, route: simNmUnits).connect().then((value){
        value is List ?
          value.length == 1 ? { currentState['unit'] = value[0].toString(), context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))) } : null
          : null; 
      });
    }
  }
  else { null; }
}