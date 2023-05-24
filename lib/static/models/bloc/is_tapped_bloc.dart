
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class IsTappedBloc extends Bloc<IsTappedEvent, bool> {
  IsTappedBloc() : super(false) {
    on<IsTappedChangeEvent>(_onChangeValueEvent);
  }

  _onChangeValueEvent(IsTappedChangeEvent event, Emitter<bool> emit){
    state == true ? emit(false) : emit(true);
  }

}


abstract class IsTappedEvent extends Equatable {
  const IsTappedEvent();

  @override
  List<Object> get props => [];
}


class IsTappedChangeEvent extends IsTappedEvent{}