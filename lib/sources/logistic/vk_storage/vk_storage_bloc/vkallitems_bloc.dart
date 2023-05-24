import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../static/api/api_routers.dart';



class VkAllItemsBloc extends Bloc<VkAllItemsEvent, List> {
  late WebSocketChannel itemsChannel;
  VkAllItemsBloc() : super(['load']) {
    on<GetVkAllItemsEvent>(_onGetValueEvent);
    on<UpdateVkAllItemsEvent>(_onUpdateState);
  }

  _onGetValueEvent(GetVkAllItemsEvent event, Emitter<List> emit) async {
    var userData = GetStorage().read('info');
    Map<String, dynamic> data = {'user_id': userData['id'].toString()};
    List allItems = [];
    bool connected = true;
    itemsChannel = WebSocketChannel.connect(Uri.parse('$mainRoute$vkAllItems'));
    await itemsChannel.ready.onError((error, stackTrace) => connected = false);

    connected ? itemsChannel.sink.add(jsonEncode(data)) : null;
    itemsChannel.stream.listen((result){
      result == null ? null : {
        allItems = jsonDecode(result),
        add(UpdateVkAllItemsEvent(data: allItems))
      };
    }, onError: _onError);
  }

  // повторная попытка подключения
  _onError(err) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      blocConnected ? {add(const UpdateVkAllItemsEvent(data: ['search'])), add(GetVkAllItemsEvent())} : null;
    });
  }

  _onUpdateState(UpdateVkAllItemsEvent event, Emitter<List> emit){
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


abstract class VkAllItemsEvent extends Equatable {
  const VkAllItemsEvent();

  @override
  List<Object> get props => [];
}


class GetVkAllItemsEvent extends VkAllItemsEvent{}

class UpdateVkAllItemsEvent extends VkAllItemsEvent{
  final List data;
  const UpdateVkAllItemsEvent({required this.data});
}


