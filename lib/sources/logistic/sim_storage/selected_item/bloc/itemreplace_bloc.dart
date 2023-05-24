
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemReplaceBloc extends Bloc<ItemReplaceEvent, Map> {
  ItemReplaceBloc() : super({'place': '', 'cell': '', 'pallet': false}) {
    on<ItemReplaceChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemReplaceChange event, Emitter<Map> emit){
    emit(event.data);
  }

}


abstract class ItemReplaceEvent extends Equatable {
  const ItemReplaceEvent();

  @override
  List<Object> get props => [];
}


class ItemReplaceChange extends ItemReplaceEvent{
  final Map data;
  const ItemReplaceChange({required this.data});
}