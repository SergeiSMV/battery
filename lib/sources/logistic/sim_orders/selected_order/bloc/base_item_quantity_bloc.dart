

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class BaseItemQuantBloc extends Bloc<BaseItemQuantEvent, String> {
  BaseItemQuantBloc() : super('') {
    on<BaseItemQuantChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(BaseItemQuantChangeEvent event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class BaseItemQuantEvent extends Equatable {
  const BaseItemQuantEvent();

  @override
  List<Object> get props => [];
}


class BaseItemQuantChangeEvent extends BaseItemQuantEvent{
  final String data;
  const BaseItemQuantChangeEvent({required this.data});
}



