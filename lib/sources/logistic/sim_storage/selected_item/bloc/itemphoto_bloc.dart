import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemPhotoBloc extends Bloc<ItemPhotoEvent, List> {
  ItemPhotoBloc() : super([]) {
    on<ItemPhotoChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemPhotoChange event, Emitter<List> emit){
    emit(event.data);
  }

}


abstract class ItemPhotoEvent extends Equatable {
  const ItemPhotoEvent();

  @override
  List<Object> get props => [];
}


class ItemPhotoChange extends ItemPhotoEvent{
  final List data;
  const ItemPhotoChange({required this.data});
}