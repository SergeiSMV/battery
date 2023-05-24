import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../bloc/additem_bloc.dart';


initAuthor(BuildContext context, Map currentState){
  if(currentState['author'] == ''){
    var authorData = GetStorage().read('info');
    String author = '${authorData['surname']} ${authorData['name'][0]}.${authorData['patronymic'][0]}.';
    currentState['author'] = author.toString();
    context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState)));
  }
  else { null; }
}