
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NomenclatureAddBloc extends Bloc<NomenclatureAddEvent, Map> {
  NomenclatureAddBloc() : super({}) {
    on<NomenclatureAddChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(NomenclatureAddChange event, Emitter<Map> emit){
    emit(event.data);
  }

}


abstract class NomenclatureAddEvent extends Equatable {
  const NomenclatureAddEvent();

  @override
  List<Object> get props => [];
}


class NomenclatureAddChange extends NomenclatureAddEvent{
  final Map data;
  const NomenclatureAddChange({required this.data});
}