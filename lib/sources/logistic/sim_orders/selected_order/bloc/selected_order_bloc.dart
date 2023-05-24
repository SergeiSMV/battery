import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../static/api/api_routers.dart';



class SelectedOrderBloc extends Bloc<SelectedOrderEvent, List> {
  late WebSocketChannel itemsChannel;
  final String num;
  SelectedOrderBloc({required this.num}) : super(['search']) {
    on<GetSelectedOrderEvent>(_onGetValueEvent);
    on<UpdateSelectedOrderEvent>(_onUpdateState);
  }

  _onGetValueEvent(GetSelectedOrderEvent event, Emitter<List> emit) async {
    var userData = GetStorage().read('info');
    Map<String, dynamic> data = {'user_id': userData['id'].toString(), 'num': num};
    List allItems = [];
    bool connected = true;
    itemsChannel = WebSocketChannel.connect(Uri.parse('$mainRoute$simOrderItems'));
    await itemsChannel.ready.onError((error, stackTrace) => connected = false);

    connected ? itemsChannel.sink.add(jsonEncode(data)) : null;
    itemsChannel.stream.listen((result){
      result == null ? null : {
        allItems = jsonDecode(result),
        add(UpdateSelectedOrderEvent(data: allItems))
      };
    }, onError: _onError);
  }

  // повторная попытка подключения
  _onError(err) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      blocConnected ? {add(const UpdateSelectedOrderEvent(data: ['search'])), add(GetSelectedOrderEvent())} : null;
    });
  }

  _onUpdateState(UpdateSelectedOrderEvent event, Emitter<List> emit){
    emit(event.data);
  }


  bool blocConnected = true;
  @override
  Future<void> close() {
    blocConnected = false;
    itemsChannel.sink.close(1000);
    return super.close();
  }

}


abstract class SelectedOrderEvent extends Equatable {
  const SelectedOrderEvent();

  @override
  List<Object> get props => [];
}


class GetSelectedOrderEvent extends SelectedOrderEvent{}

class UpdateSelectedOrderEvent extends SelectedOrderEvent{
  final List data;
  const UpdateSelectedOrderEvent({required this.data});
}



