import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../../add_item/bloc/places_bloc.dart';
import '../../bloc/isexpanded_bloc.dart';
import '../bloc/itemreplace_bloc.dart';
import '../values/set_cell.dart';
import '../values/set_place.dart';


String funcDescription = 'Данная функция позволяет изменить текущее местоположение ТМЦ. Для этого необходимо сначала выбрать склад, куда будет осуществляться перемещение, затем ячейку размещения.';


class ItemReplace extends StatelessWidget {
  final Map data;
  final BuildContext itemInfoRouterContext;
  const ItemReplace({Key? key, required this.data, required this.itemInfoRouterContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemReplaceBloc>(create: (context) => ItemReplaceBloc()),
        BlocProvider<PlacesBloc>(create: (context) => PlacesBloc()),
      ],
      child: ProgressHUD(
        barrierColor: Colors.white.withOpacity(0.7),
        child: Builder(
          builder: (context) {
            var authorData = GetStorage().read('info');
            String author = '${authorData['surname']} ${authorData['name'][0]}.${authorData['patronymic'][0]}.';
            
            String place = context.watch<ItemReplaceBloc>().state['place'];
            String cell = context.watch<ItemReplaceBloc>().state['cell'];
            bool changePallet = context.watch<ItemReplaceBloc>().state['pallet'];
            Map currentState = context.watch<ItemReplaceBloc>().state;
            Map places = context.watch<PlacesBloc>().state;
        
            String palletSize = changePallet ? 
              data['pallet_size'] == 'standart' ? 'большой' : 'стандартный' :
              data['pallet_size'] == 'standart' ? 'стандартный' : 'большой';
                
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                
                  const SizedBox(height: 15),
            
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 40,),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){ context.read<IsExpandedBloc>().add(IsExpandedChange()); }, 
                          icon: Icon(MdiIcons.closeCircle, color: firmColor),
                          iconSize: 25,
                        ),
                        Expanded(child: SizedBox(width: double.infinity, child: Text('Перемещение позиции', style: TextStyle(color: firmColor, fontSize: 16), textAlign: TextAlign.left,))),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8),
                    child: SizedBox(child: Text(funcDescription, style: TextStyle(color: firmColor, fontSize: 12), textAlign: TextAlign.justify,)),
                  ),
                  const SizedBox(height: 20),
            
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      color: place.isEmpty ? Colors.blue.shade200 : Colors.blue.shade100,
                    ),
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextButton(onPressed: (){
                      ProgressHUD.of(context)?.showWithText('ищем склады');
                      SetPlace(parrentContext: context).getPlaces();
                    }, child: Text(place.isEmpty ? 'выберите склад' : place, style: const TextStyle(color: Colors.white),))
                  ),
            
                  place.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 10),
            
                  place.isEmpty ? const SizedBox.shrink() : Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      color: cell.isEmpty ? Colors.blue.shade200 : Colors.blue.shade100,
                    ),
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextButton(onPressed: (){
                      place.isEmpty ? systemMessage(context, 'сначала укажите склад', 'lib/images/lottie/close.json') :
                      SetCell(parrentContext: context, cells: places[place]).setCell();
                    }, child: Text(cell.isEmpty ? 'выберите ячейку' : cell, style: const TextStyle(color: Colors.white),))
                  ),
            
                  place.isEmpty || cell.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 10),
            
                  place.isEmpty || cell.isEmpty ? const SizedBox.shrink() :
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Row(
                        children: [
                          Switch(
                            value: changePallet,
                            activeColor: Colors.blue.shade400,
                            activeTrackColor: Colors.grey.shade400,
                            onChanged: (bool value){
                              currentState['pallet'] = value;
                              context.read<ItemReplaceBloc>().add(ItemReplaceChange(data: Map.from(currentState)));
                            }
                          ),
                          const SizedBox(width: 10,),
                          Text(changePallet ? 'меняем на $palletSize паллет' : 'оставляем $palletSize паллет', style: TextStyle(color: firmColor, fontSize: 12))
                        ],
                      ),
                    ),
            
                  place.isEmpty || cell.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 10),
                  
                  place.isEmpty || cell.isEmpty ? const SizedBox.shrink() : 
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.blue.shade400,
                      ),
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextButton(onPressed: () async {
                        ProgressHUD.of(context)?.showWithText('перемещаем');
                        Map moveData = {
                          'itemId': data['itemId'], 'storage': place, 
                          'cell': cell, 'old_storage': data['place'], 
                          'old_cell': data['cell'], 'author': author.toString(),
                          'pallet_size': data['pallet_size'],
                          'change_pallet': changePallet ? 'yes' : 'no'
                        };
                        await Connection(data: moveData, route: simItemMove).connect().then((value){
                          ProgressHUD.of(context)?.dismiss();
                          value == 'done' ? 
                          context.read<IsExpandedBloc>().add(IsExpandedChange()) : 
                          systemMessage(context, value, 'lib/images/lottie/close.json');
                        });
                      }, child: const Text('переместить', style: TextStyle(color: Colors.white),))
                    ),
            
                  const SizedBox(height: 10)
                ],
              ),
            );
          }
        ),
      )
    );
  }
}