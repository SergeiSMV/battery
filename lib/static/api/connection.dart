import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'api_routers.dart';


class Connection{
  final Map data;
  final String route;
  Connection({ this.data = const {}, required this.route });
  
  connect() async {
    bool isConnected = true;
    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse('$mainRoute$route'));
    await channel.ready.onError((error, stackTrace) => isConnected = false);

    if(isConnected == false){
      return 'disconnected';
    } else {
      try{
        dynamic result;
        channel.sink.add(jsonEncode(data));
        await channel.stream.single.then((value) {
          result = jsonDecode(value);
        });
        return result;
      } on Error catch (_){
        return '$_ (server ERROR)';
      } on Exception catch (_){
        return '$_ (server EXCEPTION)';
      }
    }
  }
}