

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemStatusBloc extends Bloc<ItemStatusEvent, String> {
  ItemStatusBloc() : super('') {
    on<ItemStatusChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemStatusChange event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class ItemStatusEvent extends Equatable {
  const ItemStatusEvent();

  @override
  List<Object> get props => [];
}


class ItemStatusChange extends ItemStatusEvent{
  final String data;
  const ItemStatusChange({required this.data});
}