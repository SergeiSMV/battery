import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../../models/abstract_choice.dart';
import '../bloc/nomenclatureedit_bloc.dart';

class EditNomenclatureProducer extends AbstractChoice{
  final BuildContext parrentContext;
  final Map currentState;
  EditNomenclatureProducer({required this.parrentContext, required this.currentState});


  getProducers() {
    Connection(data: {}, route: simGetProducers).connect().then((value) => _checkResponce(value));
  }

  _checkResponce(dynamic responce){
    if(responce is String){
      return systemMessage(parrentContext, responce.toString(), 'lib/images/lottie/close.json');
    } else {
      return setElement(parrentContext, responce, (value){
        currentState['producer'] == value.toString() ? null : {
          currentState['producer'] = value.toString(),
          parrentContext.read<NomenclatureEditBloc>().add(NomenclatureEditChange(data: Map.from(currentState))),
        }; 
        Navigator.pop(parrentContext);
      }, 'выберете поставщика');
    }
  }
}