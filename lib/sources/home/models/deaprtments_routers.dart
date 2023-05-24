import '../../logistic/logistic.dart';
import '../../starters/ui/starters.dart';

departmentsRouters(bool singleRoute, List departments){
  
  for (var r in departments){
    r['chapter'] == 'logistic' ? r['route'] = Logistic(singleRoute: singleRoute) : null;
    r['chapter'] == 'starters' ? r['route'] = Starters(singleRoute: singleRoute) : null;
  }

  return departments;

}