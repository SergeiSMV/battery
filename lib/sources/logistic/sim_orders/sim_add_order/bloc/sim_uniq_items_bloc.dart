import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../static/api/api_routers.dart';


class SimUniqBloc extends Bloc<SimUniqEvent, List> {
  late WebSocketChannel itemsChannel;
  late List currentState;
  SimUniqBloc() : super(['load']) {
    on<GetSimUniqEvent>(_onGetValueEvent);
    on<UpdateSimUniqEvent>(_onUpdateState);
    on<SimUniqSearchEvent>(_onSearch);
    on<SimUniqClearSearchEvent>(_onClearSearch);
  }

  _onGetValueEvent(GetSimUniqEvent event, Emitter<List> emit) async {
    var userData = GetStorage().read('info');
    Map<String, dynamic> data = {'user_id': userData['id'].toString()};
    List uniqSimItemsList = [];
    bool connected = true;
    itemsChannel = WebSocketChannel.connect(Uri.parse('$mainRoute$simUniqItems'));
    await itemsChannel.ready.onError((error, stackTrace) => connected = false);

    connected ? itemsChannel.sink.add(jsonEncode(data)) : null;
    itemsChannel.stream.listen((result){
      result == null ? null : {
        uniqSimItemsList = jsonDecode(result),
        add(UpdateSimUniqEvent(data: uniqSimItemsList))
      };
    }, onError: _onError);
  }

  // повторная попытка подключения
  _onError(err) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      blocConnected ? {add(const UpdateSimUniqEvent(data: ['load'])), add(GetSimUniqEvent())} : null;
    });
  }

  _onUpdateState(UpdateSimUniqEvent event, Emitter<List> emit){
    currentState = event.data;
    emit(event.data);
  }

  _onSearch(SimUniqSearchEvent event, Emitter<List> emit){
    emit(currentState.where((search) => 
      search['category'].toLowerCase().contains(event.text) ||
      search['name'].toLowerCase().contains(event.text) || 
      search['color'].toLowerCase().contains(event.text) ||
      search['producer'].toLowerCase().contains(event.text)
      ).toList());
  }

  _onClearSearch(SimUniqClearSearchEvent event, Emitter<List> emit){
    emit(currentState);
  }

  bool blocConnected = true;
  @override
  Future<void> close() {
    blocConnected = false;
    itemsChannel.sink.close(1000);
    return super.close();
  }

}


abstract class SimUniqEvent extends Equatable {
  const SimUniqEvent();

  @override
  List<Object> get props => [];
}


class GetSimUniqEvent extends SimUniqEvent{}

class UpdateSimUniqEvent extends SimUniqEvent{
  final List data;
  const UpdateSimUniqEvent({required this.data});
}

class SimUniqClearSearchEvent extends SimUniqEvent{}


class SimUniqSearchEvent extends SimUniqEvent{
  final String text;
  const SimUniqSearchEvent({required this.text});
}


