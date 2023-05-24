
import '../../../../../static/api/api_routers.dart';
import '../../../../../static/api/connection.dart';

itemDeleteImage(Map item, String link) async {
  Map data = {'item': item, 'link': link};
  Connection(data: data, route: simDeleteImage).connect();
}