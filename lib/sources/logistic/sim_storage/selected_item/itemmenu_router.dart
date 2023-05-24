import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/isexpanded_bloc.dart';
import 'ui_elements/item_delete.dart';
import 'ui_elements/item_edit.dart';
import 'ui_elements/item_history.dart';
import 'ui_elements/item_replace.dart';
import 'ui_elements/item_status.dart';


class ItemMenuRouter extends StatelessWidget {
  final int index;
  final Map itemData;
  const ItemMenuRouter({Key? key, required this.index, required this.itemData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: ((context) {
        final isExpanded = context.watch<IsExpandedBloc>().state;
        return AnimatedContainer(
          constraints: BoxConstraints(
            maxHeight: isExpanded ? MediaQuery.of(context).size.height * 0.59 : 0
          ),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(color: Colors.amber.shade50),
          // child: isExpanded ? _menu(index, itemData, context) : const SizedBox.shrink(),
          child: _menu(index, itemData, context)
        );
      })
    );
  }

  _menu(int index, dynamic itemData, BuildContext itemMenuRouterContext){
    List<Widget> menu =[
      ItemReplace(data: itemData, itemInfoRouterContext: itemMenuRouterContext),
      ItemHistory(data: itemData, itemInfoRouterContext: itemMenuRouterContext,).getHistoryList(),
      ItemStatus(data: itemData, itemInfoRouterContext: itemMenuRouterContext,).changeItemStatus(),
      ItemEdit(itemData: itemData, itemInfoRouterContext: itemMenuRouterContext,).editItem(),
      itemDelete(itemData, itemMenuRouterContext)
    ];
    return menu[index];
  }


}