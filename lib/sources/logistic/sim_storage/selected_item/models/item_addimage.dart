import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../../static/api/api_routers.dart';
import '../../../../../static/api/connection.dart';



itemAddImage(Map item, ImageSource cmd) async {
  final getImage = await ImagePicker().pickImage(source: cmd, maxHeight: 700, maxWidth: 700);
  File image = File(getImage!.path);
  List<int> imageBytes = image.readAsBytesSync();
  var imageCode = base64Encode(imageBytes);

  Map data = {'image': imageCode, 'item_data': item};
  
  String link = await Connection(data: data, route: simAddImage).connect();
  return link;
}