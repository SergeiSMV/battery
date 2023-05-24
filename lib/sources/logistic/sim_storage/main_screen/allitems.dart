import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


import '../../../../../static/models/bloc/accesses_bloc.dart';
import '../../../../../static/ui/colors.dart';
import '../../models/item_constructor.dart';
import '../models/sim_elements.dart';
import '../selected_item/bloc/itemid_bloc.dart';
import '../selected_item/selected_item.dart';

class AllItems{
  final List allItemsState;
  final BuildContext allItemsContext;
  const AllItems({required this.allItemsState, required this.allItemsContext});

  List get items => allItemsState;


  controller(){
    Function eq = const ListEquality().equals;
    List<dynamic> compare = ['load'];
    bool result = eq(allItemsState, compare);
    
    return result ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,)) : 
      items.isEmpty ? _emptyStorage() : _allItemsViewer();
  }

  _allItemsViewer(){
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index){
        
        items.sort((a, b) {return a['category'].toString().compareTo(b['category'].toString());});
        ItemConstructor item = ItemConstructor(itemData: items[index]);
    
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow:  [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0.2, blurRadius: 0.2, offset: const Offset(0, 2))]
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                trailing: item.size == 'big' ? Icon(MdiIcons.imageSizeSelectSmall, size: 15, color: Colors.grey.shade500) : const SizedBox.shrink(),
                visualDensity: const VisualDensity(vertical: -4),
                tileColor: Colors.white,
                leading: SizedBox(
                  height: double.infinity, 
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: item.status == 'в работе' ? Colors.transparent : Colors.deepOrange.shade200, 
                    child: Text(item.cell, style: TextStyle(fontSize: 10, color: firmColor),)
                  )),
                title: Text(item.fullName, style: TextStyle(fontSize: 12, color: firmColor)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('поставщик: ${item.producer}', style: const TextStyle(fontSize: 10),),
                    Text('количество на остатке: ${item.quantity} ${item.unit}', style: const TextStyle(fontSize: 10),),
                    BlocBuilder<AccessesBloc, List>(
                      builder: ((context, state) {
                        return SimElements(blocState: state).statusGod() ? 
                        Text('id товара: ${item.id}', style: const TextStyle(fontSize: 10),) : const SizedBox.shrink();
                      })
                    ),
                  ],
                ),
                onTap: (){
                  context.read<ItemIdBloc>().add(ItemIdChange(itemId: items[index]['itemId']));
                  SelectedItem(allItemsContext: allItemsContext).selectedItem();
                },
              ),
            )
          ),
        );
      }
    );
  }

  _emptyStorage(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200, width: 200,child: Lottie.asset('lib/images/lottie/not_found.json'),),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('на складе ничего не найдено', textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 12, fontFamily: 'Montserrat')),
            ),
          ],
        ),
      ),
    );
  }

}