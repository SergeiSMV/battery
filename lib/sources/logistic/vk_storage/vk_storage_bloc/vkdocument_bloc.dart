

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class VkDocumentsBloc extends Bloc<VkDocumentsEvent, Map> {
  VkDocumentsBloc() : super({}) {
    on<VkDocumentsChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(VkDocumentsChange event, Emitter<Map> emit){
    emit(event.data);
  }

}


abstract class VkDocumentsEvent extends Equatable {
  const VkDocumentsEvent();

  @override
  List<Object> get props => [];
}


class VkDocumentsChange extends VkDocumentsEvent{
  final Map data;
  const VkDocumentsChange({required this.data});
}