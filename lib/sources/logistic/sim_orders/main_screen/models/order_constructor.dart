class OrderConstructor{
  final Map orderData;

  OrderConstructor({required this.orderData});

  String get num => orderData['num'].toString();
  String get date => orderData['date'].toString();
  String get time => orderData['time'].toString();
  String get customer => orderData['customer'].toString();
  int get status => orderData['status'];
}