
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class PlacesBloc extends Bloc<PlacesEvent, Map> {
  PlacesBloc() : super({}) {
    on<PlacesChange>(_onChangeValueEvent);
  }

  _onChangeValueEvent(PlacesChange event, Emitter<Map> emit){
    emit(event.data);
  }

}


abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object> get props => [];
}


class PlacesChange extends PlacesEvent{
  final Map data;
  const PlacesChange({required this.data});
}