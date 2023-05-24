import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../../../../../static/ui/colors.dart';
import '../../../../../../static/ui/scanner.dart';
import '../bloc/additem_bloc.dart';
import '../values/additem_category.dart';
import '../values/additem_color.dart';
import '../values/additem_name.dart';
import '../values/additem_producer.dart';
import '../values/additem_unit.dart';
import '../models/item_element.dart';

mainOptions(BuildContext context, Map currentState, List controllers) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 13),
          Container(
            decoration: BoxDecoration(color: mainColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(3)),
            child: const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
              child: Text('Основные параметры', style: TextStyle(fontSize: 12, color: Colors.white)),
            )
          ),
          Expanded(child: Divider(color: Colors.grey.shade700, indent: 5, endIndent: 30)),
        ],
      ),
      itemElement(
        'категория:',
        currentState['category'].toString(),
        'выберите категорию',
        () => {
          ProgressHUD.of(context)?.showWithText('ищем категории'),
          AddItemCategory(parrentContext: context, currentState: currentState, controllers: controllers).getCategories()
        },
      ),
      itemElement(
        'наименование:',
        currentState['name'].toString(),
        'выберите наименование',
        () => {
          ProgressHUD.of(context)?.showWithText('готовим наименования'),
          AddItemName(parrentContext: context, currentState: currentState, controllers: controllers).getNames()
        },
      ),
      itemElement(
        'поставщик:',
        currentState['producer'].toString(),
        'выберите поставщика',
        () => {
          ProgressHUD.of(context)?.showWithText('ищем поставщиков'),
          AddItemProducer(parrentContext: context, currentState: currentState, controllers: controllers).getProducer()
        },
      ),
      itemElement(
        'цвет:',
        currentState['color'].toString(),
        'выберите цвет',
        () => {
          ProgressHUD.of(context)?.showWithText('очищаем палитру'),
          AddItemColor(parrentContext: context, currentState: currentState).getColors()
        },
      ),
      itemElement(
        'штрих код:',
        currentState['barcode'].toString(),
        'сканируйте штрих код',
        () => Scanner(mainContext: context, hint: '', func: (scanContext, value) {
          currentState['barcode'] = value.toString();
          context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState)));
        }).scann(),
      ),
      itemElement(
        'ед. измерения:',
        currentState['unit'].toString(),
        'указать',
        () => {
          ProgressHUD.of(context)?.showWithText('загружаем'),
          AddItemUnit(parrentContext: context, currentState: currentState).getUnit()
        },
      ),
    ],
  );
}

addBarcode(BuildContext context, String barcode){

}
