import 'package:flutter/material.dart';

import '../../../../static/ui/system_message.dart';
import '../../sim_storage/models/sim_elements.dart';
import 'accept_extradition.dart';
import 'item_in_order.dart';
import 'scan_pallete.dart';


itemOrderTap(BuildContext soContext, Map item, SimElements userStatus){
  int status = item['status'];
  if (userStatus.soAdd() && userStatus.soOut()){
    if(status == 1){ ScannPallete(mainContext: soContext, hint: '', func: itemInOrder, orderItem: item).scann(); }
    if(status == 2){ acceptExtradition(soContext, item); }
    if(status == 3){ systemMessage(soContext, 'позиция выдана, принята и закрыта!', 'lib/images/lottie/close.json'); }
  } else {
    if (userStatus.soAdd()){
      if(status == 1){ systemMessage(soContext, 'позиция находится на сборке!', 'lib/images/lottie/close.json'); }
      if(status == 2){ acceptExtradition(soContext, item); }
      if(status == 3){ systemMessage(soContext, 'позиция выдана, принята и закрыта!', 'lib/images/lottie/close.json'); }
    }
    if (userStatus.soOut()){
      if(status == 1){ ScannPallete(mainContext: soContext, hint: '', func: itemInOrder, orderItem: item).scann(); }
      if(status == 2){ systemMessage(soContext, 'позиция выдана и ожидает приемки!', 'lib/images/lottie/close.json'); }
      if(status == 3){ systemMessage(soContext, 'позиция выдана, принята и закрыта!', 'lib/images/lottie/close.json'); }
    }
  }
}