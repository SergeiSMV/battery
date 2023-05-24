import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../static/api/api_routers.dart';


class SimAllOrdersBloc extends Bloc<SimAllOrdersEvent, List> {
  late WebSocketChannel itemsChannel;
  late List currentState;
  SimAllOrdersBloc() : super(['search']) {
    on<GetSimAllOrdersEvent>(_onGetValueEvent);
    on<UpdateSimAllOrdersEvent>(_onUpdateState);
    // on<SimOrdersSearchEvent>(_onSearch);
    // on<SimOrdersQrEvent>(_onQrSearch);
    on<SimOrdersClearSearchEvent>(_onClearSearch);
    on<UpdateStateEvent>(_onUpdateCurrentState);
  }

  _onGetValueEvent(GetSimAllOrdersEvent event, Emitter<List> emit) async {
    var userData = GetStorage().read('info');
    Map<String, dynamic> data = {'user_id': userData['id'].toString()};
    List allOrders = [];
    bool connected = true;
    itemsChannel = WebSocketChannel.connect(Uri.parse('$mainRoute$simAllOrders'));
    await itemsChannel.ready.onError((error, stackTrace) => connected = false);

    connected ? itemsChannel.sink.add(jsonEncode(data)) : null;
    itemsChannel.stream.listen((result){
      result == null ? null : {
        allOrders = jsonDecode(result),
        currentState = allOrders,
        add(UpdateSimAllOrdersEvent(data: allOrders))
      };
    }, onError: _onError);
  }

  // повторная попытка подключения
  _onError(err) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      blocConnected ? {add(const UpdateSimAllOrdersEvent(data: ['search'])), add(GetSimAllOrdersEvent())} : null;
    });
  }

  _onUpdateState(UpdateSimAllOrdersEvent event, Emitter<List> emit){
    emit(event.data);
  }

  // _onSearch(SimOrdersSearchEvent event, Emitter<List> emit){
  //   emit(currentState.where((search) => 
  //     search['category'].toLowerCase().contains(event.text) ||
  //     search['cell'].toLowerCase().contains(event.text) ||
  //     search['name'].toLowerCase().contains(event.text) || 
  //     search['color'].toLowerCase().contains(event.text) ||
  //     search['producer'].toLowerCase().contains(event.text) ||
  //     search['fifo'].toLowerCase().contains(event.text) ||
  //     search['place'].toLowerCase().contains(event.text) ||
  //     search['author'].toLowerCase().contains(event.text)
  //     ).toList());
  // }
  // _onQrSearch(SimOrdersQrEvent event, Emitter<List> emit){
  //   emit(currentState.where((search) => 
  //     search['itemId'].toString() == event.text).toList());
  // }

  _onClearSearch(SimOrdersClearSearchEvent event, Emitter<List> emit){
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


abstract class SimAllOrdersEvent extends Equatable {
  const SimAllOrdersEvent();

  @override
  List<Object> get props => [];
}


class GetSimAllOrdersEvent extends SimAllOrdersEvent{}

class UpdateSimAllOrdersEvent extends SimAllOrdersEvent{
  final List data;
  const UpdateSimAllOrdersEvent({required this.data});
}

class SimOrdersClearSearchEvent extends SimAllOrdersEvent{}


// class SimOrdersSearchEvent extends SimAllOrdersEvent{
//   final String text;
//   const SimOrdersSearchEvent({required this.text});
// }

// class SimOrdersQrEvent extends SimAllOrdersEvent{
//   final String text;
//   const SimOrdersQrEvent({required this.text});
// }

class UpdateStateEvent extends SimAllOrdersEvent{
  final List data;
  const UpdateStateEvent({required this.data});
}


