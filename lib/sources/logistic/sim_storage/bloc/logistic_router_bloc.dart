import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class LogisticRouterBloc extends Bloc<LogisticRouterEvent, int> {
  LogisticRouterBloc() : super(0) {
    on<LogisticRouterChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(LogisticRouterChange event, Emitter<int> emit){
    emit(event.index);
  }

}


abstract class LogisticRouterEvent extends Equatable {
  const LogisticRouterEvent();

  @override
  List<Object> get props => [];
}


class LogisticRouterChange extends LogisticRouterEvent{
  final int index;
  const LogisticRouterChange({required this.index});
}