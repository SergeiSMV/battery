
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ProducersBloc extends Bloc<ProducersEvent, List> {
  ProducersBloc() : super(['load']) {
    on<ProducersChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(ProducersChange event, Emitter<List> emit){
    emit(event.data);
  }

}


abstract class ProducersEvent extends Equatable {
  const ProducersEvent();

  @override
  List<Object> get props => [];
}


class ProducersChange extends ProducersEvent{
  final List data;
  const ProducersChange({required this.data});
}