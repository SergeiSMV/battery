import '../../static/ui/no_accesse.dart';
import '../home/models/elements_name.dart';
import 'sim_orders/main_screen/ui/sim_orders.dart';
import 'sim_storage/main_screen/sim_storage.dart';
import 'vk_storage/vk_storage.dart';

sortDepartmentElements(List accesses, String depence){
  List elements = [];
  int index = 0;

  for (var e in accesses){
    // разделы департамента логистики
    e['depence'] == depence && e['chapter'] == nameSimStorage ? { 
      e['route'] = const SimStorage(), e['index'] = index, index = index +1,  elements.add(e) } : null;
    e['depence'] == depence && e['chapter'] == nameSimOrders ? { 
      e['route'] = const SimOrders(), e['index'] = index, index = index +1,  elements.add(e) } : null;
    e['depence'] == depence && e['chapter'] == nameVkStorage ? { 
      e['route'] = const VkStorage(), e['index'] = index, index = index +1,  elements.add(e) } : null;
  }

  if (elements.isEmpty){
    return [noAccesse()];
  }
  else{
    return elements;
  }

}