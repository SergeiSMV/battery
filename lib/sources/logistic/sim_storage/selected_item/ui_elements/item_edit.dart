import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../../bloc/isexpanded_bloc.dart';
import '../bloc/itemedit_bloc.dart';
import '../values/set_category.dart';
import '../values/set_color.dart';
import '../values/set_name.dart';
import '../values/set_producer.dart';
import '../values/set_unit.dart';




class ItemEdit{
  final Map itemData;
  final BuildContext itemInfoRouterContext;
  const ItemEdit({Key? key, required this.itemData, required this.itemInfoRouterContext});

  

  editItem(){
    var authorData = GetStorage().read('info');
    String author = '${authorData['surname']} ${authorData['name'][0]}.${authorData['patronymic'][0]}.';

    // ItemConstructor item = ItemConstructor(itemData: itemData);

    Map initBloc = {
      'category': itemData['category'], 
      'name': itemData['name'], 
      'color': itemData['color'], 
      'producer': itemData['producer'], 
      'quantity': itemData['quantity'].toString(),
      'unit': itemData['unit']
    };


    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemEditBloc>(create: (context) => ItemEditBloc()..add(ItemEditChange(data: initBloc))),
      ], 
      child: ProgressHUD(
        child: Builder(
          builder: (context){
      
            Widget box = const SizedBox(height: 5);
          
            String category = context.watch<ItemEditBloc>().state['category'].toString();
            String name = context.watch<ItemEditBloc>().state['name'].toString();
            String color = context.watch<ItemEditBloc>().state['color'].toString();
            String producer = context.watch<ItemEditBloc>().state['producer'].toString();
            String quantity = context.watch<ItemEditBloc>().state['quantity'].toString();
            String unit = context.watch<ItemEditBloc>().state['unit'].toString();
      
            Map blocState = context.watch<ItemEditBloc>().state;
      
            List<String> defaultValues = [itemData['category'], itemData['name'], itemData['color'], itemData['producer'], itemData['quantity'].toString(), itemData['unit']];
            List<String> editValues = [category, name, color, producer, quantity, unit];
            Function eq = const ListEquality().equals;
            bool compire = eq(defaultValues, editValues);
      
            Map editData = {'itemId': itemData['itemId'], 'default': itemData, 
            'category': category, 'name': name, 'color': color, 'producer': producer, 
            'quantity': quantity, 'unit': unit, 'author': author.toString()};
      
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
      
                  const SizedBox(height: 10),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 40,),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){ context.read<IsExpandedBloc>().add(IsExpandedChange()); }, 
                          icon: Icon(MdiIcons.closeCircle, color: firmColor),
                          iconSize: 25,
                        ),
                        Expanded(child: SizedBox(width: double.infinity, child: Text('Редактирование позиции', style: TextStyle(color: firmColor, fontSize: 16), textAlign: TextAlign.left,))),
                      ],
                    ),
                  ),
                           
                  Flexible(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        _itemElement('категория:', category, 'выберите категорию', () => {
                          ProgressHUD.of(context)?.showWithText('ищем категории'),
                          SetCategory(currentState: blocState, itemEditContext: context).getCategories()
                        }),
                        box,
                        _itemElement('наименование:', name, 'выберите наименование', () => {
                          ProgressHUD.of(context)?.showWithText('ищем наименование'),
                          SetName(currentState: blocState, itemEditContext: context).getNames()
                        }),
                        box,
                        _itemElement('цвет:', color, 'выберите цвет', () => {
                          ProgressHUD.of(context)?.showWithText('подбираем цвета'),
                          SetColor(currentState: blocState, itemEditContext: context).getColors()
                        }),
                        box,
                        _itemElement('поставщик:', producer, 'выберите поставщика', () => {
                          ProgressHUD.of(context)?.showWithText('ищем поставщиков'),
                          SetProducer(currentState: blocState, itemEditContext: context).getProducer()
                        }),
                        box,
                        _enterValue('количество:', quantity, TextInputType.number, (value) { blocState['quantity'] = value; context.read<ItemEditBloc>().add(ItemEditChange(data: Map.from(blocState))); },),
                        box,
                        _itemElement('ед. измерения:', unit, 'указать', () => {
                          ProgressHUD.of(context)?.showWithText('ищем поставщиков'),
                          SetUnit(currentState: blocState, itemEditContext: context).getUnit()
                        }),
                        box,
            
                      ],
                    ),
                  ),
            
                  // ignore: unrelated_type_equality_checks
                  name.isEmpty || producer.isEmpty || quantity == 0 || unit.isEmpty || compire ? 
                  const SizedBox.shrink() :
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.blue.shade400,
                    ),
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: TextButton(onPressed: () async {
                      ProgressHUD.of(context)?.showWithText('вносим изменения');
                      await Connection(data: editData, route: simItemEdit).connect().then((value){
                        ProgressHUD.of(context)?.dismiss();
                        value == 'done' ? context.read<IsExpandedBloc>().add(IsExpandedChange()) :
                        systemMessage(context, value, 'lib/images/lottie/close.json');
                      });
                    }, child: const Text('сохранить', style: TextStyle(color: Colors.white),))
                  ),
      
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.9),
                    child: const SizedBox(height: 15),
                  ),
                ],
              ),
            );
          }
        ),
      )
    );
  }

  _itemElement(String leading, String blocText, String blocEmpty, Function func,){
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: GestureDetector(
        child: Container(
          height: 45,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(leading, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(blocText.isEmpty ? blocEmpty : blocText, style: TextStyle(fontSize: 13, color: blocText.isEmpty ? Colors.grey : firmColor),)
              ),
            ],
          ),
        ),
        onTap: (){ func(); },
      ),
    );
  }

  _enterValue(String leading, String hint, TextInputType type, change){
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(leading, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  readOnly: false,
                  keyboardType: type,
                  style: TextStyle(fontSize: 13, color: firmColor),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontFamily: 'Montserrat'),
                    hintText: hint,
                  ),
                  onChanged: (value){ change(value); },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}