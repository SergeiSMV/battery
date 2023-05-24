
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NomenclatureBloc extends Bloc<NomenclatureEvent, List> {
  NomenclatureBloc() : super(['load']) {
    on<NomenclatureChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(NomenclatureChange event, Emitter<List> emit){
    emit(event.data);
  }

}


abstract class NomenclatureEvent extends Equatable {
  const NomenclatureEvent();

  @override
  List<Object> get props => [];
}


class NomenclatureChange extends NomenclatureEvent{
  final List data;
  const NomenclatureChange({required this.data});
}