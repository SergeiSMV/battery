
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemMenuIndexBloc extends Bloc<ItemMenuIndexEvent, int> {
  ItemMenuIndexBloc() : super(0) {
    on<ItemMenuIndexChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemMenuIndexChange event, Emitter<int> emit){
    emit(event.data);
  }

}


abstract class ItemMenuIndexEvent extends Equatable {
  const ItemMenuIndexEvent();

  @override
  List<Object> get props => [];
}


class ItemMenuIndexChange extends ItemMenuIndexEvent{
  final int data;
  const ItemMenuIndexChange({required this.data});
}