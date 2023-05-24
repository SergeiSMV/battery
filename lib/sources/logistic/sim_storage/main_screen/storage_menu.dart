import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../static/api/api_routers.dart';
import '../../../../../static/api/connection.dart';
import '../../../../../static/ui/scanner.dart';
import '../../../../../static/ui/system_message.dart';
import '../add_item/add_item.dart';
import '../colors/ui/item_colors.dart';
import '../models/sim_elements.dart';
import '../nomenclature/nomenclature.dart';
import '../producers/producers.dart';
import '../bloc/isexpanded_bloc.dart';
import 'bloc/allitems_bloc.dart';




storageMenu(BuildContext context, List accesses){
  bool searchBarExpanded = context.watch<IsExpandedBloc>().state;
  SimElements simElements = SimElements(blocState: accesses);
  Color iconColor = Colors.white;
  
  List elements = [
    // кнопка поиска в ручном режиме
    IconButton(onPressed: (){ 
      context.read<AllItemsBloc>().add(SimStorageClearSearchEvent());
      context.read<IsExpandedBloc>().add(IsExpandedChange()); 
    }, icon: Icon(MdiIcons.magnify, size: 25, color: iconColor,), splashRadius: 0.1,),
    
    // кнопка поиска по QR коду
    IconButton(onPressed: (){
      searchBarExpanded ? context.read<IsExpandedBloc>().add(IsExpandedChange()) : null;
      Scanner(mainContext: context, hint: '', func: _searchBarValue).scann();
    }, icon: Icon(MdiIcons.qrcode, size: 25, color: iconColor,), splashRadius: 0.1,),
  ];

  // кнопка добавления позиции (приход)
  simElements.ssAdd() ? elements.add(
    IconButton(onPressed: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddItem()));
    }, icon: Icon(MdiIcons.packageVariantClosedPlus, size: 25, color: iconColor,), splashRadius: 0.1,)
  ) : null;

  // кнопка управления номенклатурой
  simElements.sspNmncl() ? elements.add(
    IconButton(onPressed: (){
      Connection(data: {}, route: simGetNomenclature).connect().then((value) 
        { 
          value is List ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => Nomenclature(nomenclature: value))) : 
          systemMessage(context, value.toString(), 'lib/images/lottie/close.json'); 
        });
    }, icon: Icon(MdiIcons.listBoxOutline, size: 25, color: iconColor,), splashRadius: 0.1,)
  ) : null;

  // кнопка управления цветом комплектующих
  simElements.sspColor() ? elements.add(
    IconButton(onPressed: (){
      Connection(data: {}, route: simGetMapColors).connect().then((value) 
        {
          value is List ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemColors(colors: value))) : 
          systemMessage(context, value.toString(), 'lib/images/lottie/close.json'); 
        });
    }, icon: Icon(MdiIcons.paletteOutline, size: 25, color: iconColor,), splashRadius: 0.1,)
  ) : null;

  // кнопка управления поставщиками
  simElements.sspPrdcr() ? elements.add(
    IconButton(onPressed: (){
      Connection(data: {}, route: simGetMapProducers).connect().then((value) 
        {
          value is List ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => Producers(producers: value))) : 
          systemMessage(context, value.toString(), 'lib/images/lottie/close.json'); 
        });
    }, icon: Icon(MdiIcons.cardAccountDetailsOutline, size: 25, color: iconColor,), splashRadius: 0.1,)
  ) : null;
  
  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [...elements]);

}

_searchBarValue(BuildContext mainContext, String qrcode) {
  mainContext.read<AllItemsBloc>().add(SimStorageQrEvent(text: qrcode));
}