import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class PasswordBloc extends Bloc<PasswordEvent, String> {
  PasswordBloc() : super('') {
    on<PasswordChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(PasswordChangeEvent event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}


class PasswordChangeEvent extends PasswordEvent{
  final String data;
  const PasswordChangeEvent({required this.data});
}