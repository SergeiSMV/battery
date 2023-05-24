
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AddItemBloc extends Bloc<AddItemEvent, Map> {
  AddItemBloc() : super({}) {
    on<AddItemChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(AddItemChange event, Emitter<Map> emit){
    emit(event.data);
  }

}


abstract class AddItemEvent extends Equatable {
  const AddItemEvent();

  @override
  List<Object> get props => [];
}


class AddItemChange extends AddItemEvent{
  final Map data;
  const AddItemChange({required this.data});
}