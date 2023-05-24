

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class QuantityBloc extends Bloc<QuantityEvent, String> {
  QuantityBloc() : super('') {
    on<QuantityChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(QuantityChangeEvent event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class QuantityEvent extends Equatable {
  const QuantityEvent();

  @override
  List<Object> get props => [];
}


class QuantityChangeEvent extends QuantityEvent{
  final String data;
  const QuantityChangeEvent({required this.data});
}