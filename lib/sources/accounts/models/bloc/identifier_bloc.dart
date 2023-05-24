import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class IdentifierBloc extends Bloc<IdentifierEvent, String> {
  IdentifierBloc() : super('') {
    on<IdentifierChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(IdentifierChangeEvent event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class IdentifierEvent extends Equatable {
  const IdentifierEvent();

  @override
  List<Object> get props => [];
}


class IdentifierChangeEvent extends IdentifierEvent{
  final String data;
  const IdentifierChangeEvent({required this.data});
}