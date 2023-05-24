
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemEditBloc extends Bloc<ItemEditEvent, Map> {
  ItemEditBloc() : super({}) {
    on<ItemEditChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemEditChange event, Emitter<Map> emit){
    emit(event.data);
  }

}


abstract class ItemEditEvent extends Equatable {
  const ItemEditEvent();

  @override
  List<Object> get props => [];
}


class ItemEditChange extends ItemEditEvent{
  final Map data;
  const ItemEditChange({required this.data});
}