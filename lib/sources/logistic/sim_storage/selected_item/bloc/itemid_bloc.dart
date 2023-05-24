import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemIdBloc extends Bloc<ItemIdEvent, int> {
  ItemIdBloc() : super(0) {
    on<ItemIdChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemIdChange event, Emitter<int> emit){
    emit(event.itemId);
  }

}


abstract class ItemIdEvent extends Equatable {
  const ItemIdEvent();

  @override
  List<Object> get props => [];
}


class ItemIdChange extends ItemIdEvent{
  final int itemId;
  const ItemIdChange({required this.itemId});
}