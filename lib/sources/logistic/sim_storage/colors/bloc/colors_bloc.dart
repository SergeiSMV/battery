
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ColorsBloc extends Bloc<ColorsEvent, List> {
  ColorsBloc() : super(['load']) {
    on<ColorsChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ColorsChange event, Emitter<List> emit){
    emit(event.data);
  }

}


abstract class ColorsEvent extends Equatable {
  const ColorsEvent();

  @override
  List<Object> get props => [];
}


class ColorsChange extends ColorsEvent{
  final List data;
  const ColorsChange({required this.data});
}