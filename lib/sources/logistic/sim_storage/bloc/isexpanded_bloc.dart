
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class IsExpandedBloc extends Bloc<IsExpandedEvent, bool> {
  IsExpandedBloc() : super(false) {
    on<IsExpandedChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(IsExpandedChange event, Emitter<bool> emit){
    state == true ? emit(false) : emit(true);
  }

}


abstract class IsExpandedEvent extends Equatable {
  const IsExpandedEvent();

  @override
  List<Object> get props => [];
}


class IsExpandedChange extends IsExpandedEvent{}