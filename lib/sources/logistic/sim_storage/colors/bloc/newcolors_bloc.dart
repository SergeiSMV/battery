

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NewColorsBloc extends Bloc<NewColorsEvent, String> {
  NewColorsBloc() : super('укажите новый цвет') {
    on<NewColorsChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(NewColorsChange event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class NewColorsEvent extends Equatable {
  const NewColorsEvent();

  @override
  List<Object> get props => [];
}


class NewColorsChange extends NewColorsEvent{
  final String data;
  const NewColorsChange({required this.data});
}