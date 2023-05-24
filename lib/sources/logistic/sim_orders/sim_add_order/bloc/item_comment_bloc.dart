

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ItemCommentBloc extends Bloc<ItemCommentEvent, String> {
  ItemCommentBloc() : super('') {
    on<ItemCommentChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ItemCommentChangeEvent event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class ItemCommentEvent extends Equatable {
  const ItemCommentEvent();

  @override
  List<Object> get props => [];
}


class ItemCommentChangeEvent extends ItemCommentEvent{
  final String data;
  const ItemCommentChangeEvent({required this.data});
}