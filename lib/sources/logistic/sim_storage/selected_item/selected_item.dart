import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/models/bloc/accesses_bloc.dart';
import '../../../../../static/ui/colors.dart';
import '../main_screen/bloc/allitems_bloc.dart';
import '../models/sim_elements.dart';
import '../bloc/isexpanded_bloc.dart';
import 'bloc/itemhistory_bloc.dart';
import 'bloc/itemid_bloc.dart';
import 'bloc/itemmenu_index_bloc.dart';
import 'bloc/itemphoto_bloc.dart';
import 'item_buttons.dart';
import 'item_card.dart';
import 'models/item_accesses.dart';
import 'ui_elements/item_image.dart';
import 'item_menu.dart';
import 'itemmenu_router.dart';




class SelectedItem{
  final BuildContext allItemsContext;
  const SelectedItem({required this.allItemsContext});


  selectedItem(){
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: allItemsContext, 
      builder: (context){
        List allItems = allItemsContext.read<AllItemsBloc>().state;
        int itemId = allItemsContext.read<ItemIdBloc>().state;
        Map itemData = allItems.firstWhere((item) => item['itemId'] == itemId);
        return MultiBlocProvider(
          providers: [
            BlocProvider<IsExpandedBloc>(create: (context) => IsExpandedBloc()),
            BlocProvider<ItemMenuIndexBloc>(create: (context) => ItemMenuIndexBloc()),
            BlocProvider<ItemHistoryBloc>(create: (context) => ItemHistoryBloc()),
            BlocProvider<ItemPhotoBloc>(create: (context) => ItemPhotoBloc()..add(ItemPhotoChange(data: itemData['images'].toList()))),
          ],
          child: Builder(
            builder: (context){
          
              List allItems = allItemsContext.watch<AllItemsBloc>().state;
              int itemId = allItemsContext.watch<ItemIdBloc>().state;
              int menuIndex = context.watch<ItemMenuIndexBloc>().state;
              bool isExpanded = context.watch<IsExpandedBloc>().state;
          
              Map itemData = allItems.firstWhere((item) => item['itemId'] == itemId);
              SimElements simElements = SimElements(blocState: context.watch<AccessesBloc>().state);
              ItemButtons buttons = ItemButtons(selectedItemContext: context, itemData: itemData);
              ItemButtonAccess buttonsAccesses = ItemButtonAccess(simElements: simElements);
          
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                child: Stack(
                  children: [
          
                    SizedBox(child: Image.asset('lib/images/selected_item.png'),),
          
                    Padding(
                      padding: const EdgeInsets.only(top: 90),
                      child: Container(
                        color: const Color(0xFFffd77e),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                      
                            isExpanded ? const SizedBox.shrink() :
                              BlocBuilder<ItemPhotoBloc, List>(
                                builder: ((context, state) {
                                  return state.isEmpty ? Image.asset('lib/images/no_photo.png', scale: 3.0, color: firmColor,) :
                                    itemImages(state, buttons, buttonsAccesses,);
                                })
                              ),
                      
                            itemCard(context, itemData, isExpanded),
                            const SizedBox(height: 15),
                            Flexible(child: ItemMenuRouter(index: menuIndex, itemData: itemData)),
                            itemPanel(context, buttonsAccesses, buttons)
                          ]
                        ),
                      ),
                    ),
          
                  ],
                )
              );
            }
          ),
        );
      }
    ).whenComplete(() => allItemsContext.read<AllItemsBloc>().add(SimStorageClearSearchEvent()));
  }
}
