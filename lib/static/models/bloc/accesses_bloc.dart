import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../api/api_routers.dart';


class AccessesBloc extends Bloc<AccessesEvent, List> {
  late WebSocketChannel accessChannel;
  AccessesBloc() : super(['load']) {
    on<GetAccessesEvent>(_onGetAccessPages);
    on<UpdateAccessesEvent>(_onUpdateState);
  }

  _onGetAccessPages(GetAccessesEvent event, Emitter<List> emit) async {
    var userData = GetStorage().read('info');
    Map<String, dynamic> data = {'user_id': userData['id'].toString()};
    List chapters;
    bool connected = true;
    accessChannel = WebSocketChannel.connect(Uri.parse('$mainRoute$chapterAccessRoute'));
    await accessChannel.ready.onError((error, stackTrace) => connected = false);

    connected ? accessChannel.sink.add(jsonEncode(data)) : null;
    accessChannel.stream.listen((result){
      result == null ? null : {
        chapters = jsonDecode(result),
        add(UpdateAccessesEvent(data: chapters))
      };
    }, onError: _onError);
  }

  // повторная попытка подключения
  _onError(err) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      blocConnected ? {add(const UpdateAccessesEvent(data: ['load'])), add(GetAccessesEvent())} : null;
    });
  }

  _onUpdateState(UpdateAccessesEvent event, Emitter<List> emit){
    emit(event.data);
  }

  bool blocConnected = true;
  @override
  Future<void> close() {
    blocConnected = false;
    accessChannel.sink.close(1000);
    return super.close();
  }

}


abstract class AccessesEvent extends Equatable {
  const AccessesEvent();

  @override
  List<Object> get props => [];
}


class GetAccessesEvent extends AccessesEvent{}

class UpdateAccessesEvent extends AccessesEvent{
  final List data;
  const UpdateAccessesEvent({required this.data});
}


