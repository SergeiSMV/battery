import 'items_exceptions.dart';

bool checkFills(Map cs){
  if(itemsExceptions.contains(cs['category'].toString().toLowerCase())){
    if(cs['producer'].toString().isEmpty || 
    cs['unit'].toString().isEmpty || 
    cs['pallet_quantity'] == '0' || 
    cs['quantity'] == '0'){
      return true;
    } else {
      return false;
    }
  } else {
    if(cs['producer'].toString().isEmpty || 
    cs['unit'].toString().isEmpty || 
    cs['pallet_row'] == '0' || 
    cs['pallet_quantity'] == '0' || 
    cs['quantity'] == '0' || 
    cs['box_size'] == '0x0x0' && cs['base_box_size'] == '0x0x0'
    ){
      if (cs['cell'].toString().isNotEmpty){
        return false;
      } else { return true; }
    } else {
      return false;
    }
  }
}