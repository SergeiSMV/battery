

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/additem_bloc.dart';


initDate(BuildContext context, Map currentState){
  if(currentState['fifo'] == ''){
    var now = DateTime.now();
    var formatter = DateFormat('dd.MM.yyyy');
    String today = formatter.format(now);
    currentState['fifo'] = today.toString();
    context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState)));
  }
  else { null; }
}


updateDate(BuildContext context, String selectedDate, Map currentState){
  currentState['fifo'] == selectedDate.toString() ? null : 
  {
    currentState['fifo'] = selectedDate.toString(),
    context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState)))
  };
}

