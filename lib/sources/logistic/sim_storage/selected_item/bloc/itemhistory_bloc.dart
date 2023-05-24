
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemHistoryBloc extends Bloc<ItemHistoryEvent, List> {
  ItemHistoryBloc() : super([]) {
    on<ItemHistoryChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemHistoryChange event, Emitter<List> emit){
    emit(event.data);
  }

}


abstract class ItemHistoryEvent extends Equatable {
  const ItemHistoryEvent();

  @override
  List<Object> get props => [];
}


class ItemHistoryChange extends ItemHistoryEvent{
  final List data;
  const ItemHistoryChange({required this.data});
}