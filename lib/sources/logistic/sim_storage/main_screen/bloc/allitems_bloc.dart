import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../static/api/api_routers.dart';



class AllItemsBloc extends Bloc<SimAllItemsEvent, List> {
  late WebSocketChannel itemsChannel;
  late List currentState;
  AllItemsBloc() : super(['load']) {
    on<GetSimAllItemsEvent>(_onGetValueEvent);
    on<UpdateSimAllItemsEvent>(_onUpdateState);
    on<SimStorageSearchEvent>(_onSearch);
    on<SimStorageQrEvent>(_onQrSearch);
    on<SimStorageClearSearchEvent>(_onClearSearch);
    on<UpdateStateEvent>(_onUpdateCurrentState);
  }

  _onGetValueEvent(GetSimAllItemsEvent event, Emitter<List> emit) async {
    var userData = GetStorage().read('info');
    Map<String, dynamic> data = {'user_id': userData['id'].toString()};
    List allItems = [];
    bool connected = true;
    itemsChannel = WebSocketChannel.connect(Uri.parse('$mainRoute$simAllItems'));
    await itemsChannel.ready.onError((error, stackTrace) => connected = false);

    connected ? itemsChannel.sink.add(jsonEncode(data)) : null;
    itemsChannel.stream.listen((result){
      result == null ? null : {
        allItems = jsonDecode(result),
        currentState = allItems,
        add(UpdateSimAllItemsEvent(data: allItems))
      };
    }, onError: _onError);
  }

  // повторная попытка подключения
  _onError(err) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      blocConnected ? {add(const UpdateSimAllItemsEvent(data: ['load'])), add(GetSimAllItemsEvent())} : null;
    });
  }

  _onUpdateState(UpdateSimAllItemsEvent event, Emitter<List> emit){
    emit(event.data);
  }

  _onSearch(SimStorageSearchEvent event, Emitter<List> emit){
    emit(currentState.where((search) => 
      search['category'].toLowerCase().contains(event.text) ||
      search['cell'].toLowerCase().contains(event.text) ||
      search['name'].toLowerCase().contains(event.text) || 
      search['color'].toLowerCase().contains(event.text) ||
      search['producer'].toLowerCase().contains(event.text) ||
      search['fifo'].toLowerCase().contains(event.text) ||
      search['place'].toLowerCase().contains(event.text) ||
      search['author'].toLowerCase().contains(event.text)
      ).toList());
  }

  _onQrSearch(SimStorageQrEvent event, Emitter<List> emit){
    emit(currentState.where((search) => 
      search['itemId'].toString() == event.text).toList());
    state.isEmpty ? Future.delayed(const Duration(seconds: 3)).then((value) {
      add(SimStorageClearSearchEvent());
    }) : null;
  }

  _onClearSearch(SimStorageClearSearchEvent event, Emitter<List> emit){
    emit(currentState);
  }

  _onUpdateCurrentState(UpdateStateEvent event, Emitter<List> emit){
    currentState = event.data;
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


abstract class SimAllItemsEvent extends Equatable {
  const SimAllItemsEvent();

  @override
  List<Object> get props => [];
}


class GetSimAllItemsEvent extends SimAllItemsEvent{}

class UpdateSimAllItemsEvent extends SimAllItemsEvent{
  final List data;
  const UpdateSimAllItemsEvent({required this.data});
}

class SimStorageClearSearchEvent extends SimAllItemsEvent{}


class SimStorageSearchEvent extends SimAllItemsEvent{
  final String text;
  const SimStorageSearchEvent({required this.text});
}

class SimStorageQrEvent extends SimAllItemsEvent{
  final String text;
  const SimStorageQrEvent({required this.text});
}

class UpdateStateEvent extends SimAllItemsEvent{
  final List data;
  const UpdateStateEvent({required this.data});
}


