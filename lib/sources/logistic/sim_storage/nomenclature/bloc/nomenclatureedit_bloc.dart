
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NomenclatureEditBloc extends Bloc<NomenclatureEditEvent, Map> {
  NomenclatureEditBloc() : super({}) {
    on<NomenclatureEditChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(NomenclatureEditChange event, Emitter<Map> emit){
    emit(event.data);
  }

}


abstract class NomenclatureEditEvent extends Equatable {
  const NomenclatureEditEvent();

  @override
  List<Object> get props => [];
}


class NomenclatureEditChange extends NomenclatureEditEvent{
  final Map data;
  const NomenclatureEditChange({required this.data});
}