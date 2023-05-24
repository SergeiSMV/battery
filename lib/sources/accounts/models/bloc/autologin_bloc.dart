import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AutoLoginBloc extends Bloc<AutoLoginEvent, bool> {
  AutoLoginBloc() : super(false) {
    on<AutoLoginChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(AutoLoginChangeEvent event, Emitter<bool> emit){
    emit(event.data);
  }

}


abstract class AutoLoginEvent extends Equatable {
  const AutoLoginEvent();

  @override
  List<Object> get props => [];
}


class AutoLoginChangeEvent extends AutoLoginEvent{
  final bool data;
  const AutoLoginChangeEvent({required this.data});
}