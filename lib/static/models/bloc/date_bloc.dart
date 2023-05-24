import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class DateBloc extends Bloc<DateEvent, String> {
  DateBloc() : super('') {
    on<DateChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(DateChangeEvent event, Emitter<String> emit){
    emit(event.data);
  }

}


abstract class DateEvent extends Equatable {
  const DateEvent();

  @override
  List<Object> get props => [];
}


class DateChangeEvent extends DateEvent{
  final String data;
  const DateChangeEvent({required this.data});
}