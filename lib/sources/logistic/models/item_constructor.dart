class ItemConstructor{
  final Map itemData;

  ItemConstructor({required this.itemData});

  String get id => itemData['itemId'].toString();
  String get place => itemData['place'].toString();
  String get cell => itemData['cell'].toString();
  String get category => itemData['category'].toString();
  String get name => itemData['name'].toString();
  String get color => itemData['color'].toString();
  String get fullName => '${itemData['category']} ${itemData['name']} ${itemData['color']}';
  String get producer => itemData['producer'].toString();
  String get quantity => itemData['quantity'].toString();
  String get reserve => itemData['reserve'].toString();
  String get unit => itemData['unit'].toString();
  String get fifo => itemData['fifo'].toString();
  String get author => itemData['author'].toString();
  String get status => itemData['status'] == 'work' ? 'в работе' : 'движение приостановлено';
  String get size => itemData['pallet_size'].toString();

}