

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NewProducersBloc extends Bloc<NewProducersEvent, String> {
  NewProducersBloc() : super('укажите поставщика') {
    on<NewProducersChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(NewProducersChange event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class NewProducersEvent extends Equatable {
  const NewProducersEvent();

  @override
  List<Object> get props => [];
}


class NewProducersChange extends NewProducersEvent{
  final String data;
  const NewProducersChange({required this.data});
}