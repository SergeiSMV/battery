

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemQuantityBloc extends Bloc<ItemQuantityEvent, String> {
  ItemQuantityBloc() : super('') {
    on<ItemQuantityChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemQuantityChangeEvent event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class ItemQuantityEvent extends Equatable {
  const ItemQuantityEvent();

  @override
  List<Object> get props => [];
}


class ItemQuantityChangeEvent extends ItemQuantityEvent{
  final String data;
  const ItemQuantityChangeEvent({required this.data});
}