import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


import '../../../../../static/ui/colors.dart';
import '../../../../static/api/api_routers.dart';
import '../../../../static/api/connection.dart';
import '../../../../static/models/bloc/is_tapped_bloc.dart';
import '../../models/item_constructor.dart';
import 'bloc/order_cart_bloc.dart';
import 'order_dialog.dart';
import 'order_edit_dialog.dart';

class SimUniqItems{
  final List uniqItems;
  final BuildContext addOrderContext;
  const SimUniqItems({required this.uniqItems, required this.addOrderContext});

  List get items => uniqItems;

  


  controller(){
    Function eq = const ListEquality().equals;
    List<dynamic> compare = ['load'];
    bool result = eq(uniqItems, compare);
    
    return result ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,)) : 
      items.isEmpty ? _emptyStorage() : _uniqItemsViewer();
  }

  _uniqItemsViewer(){
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderCartBloc>(create: (context) => OrderCartBloc()),
        BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc()),
      ], 
      child: Builder(
        builder: (context){
          var userData = GetStorage().read('info');
          String author = '${userData['surname']} ${userData['name'][0]}.${userData['patronymic'][0]}.';

          List cart = context.watch<OrderCartBloc>().state;
          items.sort((a, b) {return a['category'].toString().compareTo(b['category'].toString());});
          bool isTapped = context.watch<IsTappedBloc>().state;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: BlocBuilder<OrderCartBloc, List>(
                  builder: ((context, state){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index){

                        ItemConstructor item = ItemConstructor(itemData: items[index]);
                        Color cardColor = uiCheckQuantity(state, items[index]) == -1 ? Colors.white : Colors.orange.shade50;
                        int quantity = uiCheckQuantity(state, items[index]) == -1 ? items[index]['quantity'] : uiCheckQuantity(state, items[index]);
                        String comment = uiGetComment(state, items[index]);
                        int inOrder = items[index]['quantity'] - quantity;

                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                visualDensity: const VisualDensity(vertical: -4),
                                tileColor: Colors.white,
                                title: Text(item.fullName, style: TextStyle(fontSize: 12, color: firmColor)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('поставщик: ${item.producer}', style: const TextStyle(fontSize: 10)),
                                    Text('остаток на складе:  $quantity ${item.unit}', style: const TextStyle(fontSize: 10)),
                                    uiCheckQuantity(state, items[index]) == -1 ? const SizedBox.shrink() : Text('заказано:  $inOrder ${item.unit}', style: const TextStyle(fontSize: 10)),
                                    comment.isEmpty ? const SizedBox.shrink() : Text('комментарий:  $comment', style: const TextStyle(fontSize: 10)),
                                  ],
                                ),
                                trailing: uiCheckQuantity(state, items[index]) == -1 ? const SizedBox.shrink() : 
                                  IconButton(icon: Icon(MdiIcons.fileDocumentEdit, size: 25, color: Colors.grey.shade700), onPressed: () { 
                                    EditOrderDialog(item: items[index], mainContext: context, remainder: quantity, inOrder: inOrder, comment: comment).dialog();
                                   } 
                                  ),
                                onTap: () {
                                  quantity == 0 ? 
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Нет остатка на складе. При необходимости отредактируйте позицию.'), duration: Duration(seconds: 5),))
                                  :
                                  OrderDialog(item: items[index], mainContext: context, remainder: quantity).dialog();
                                }
                              ),
                            ),
                          ),
                        );

                      }
                    );
                  }),
                )
              ),

              cart.isEmpty ? const SizedBox.shrink() :
                isTapped == false ?
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Container(
                      height: 35,
                      width: double.infinity,
                      decoration: BoxDecoration(color: mainColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                      child: TextButton(onPressed: () async {
                        context.read<IsTappedBloc>().add(IsTappedChangeEvent());
                        Map orderData = {'items': cart, 'author': author};
                        await Connection(data: orderData, route: simAddOrder).connect().then((value)=> Navigator.pop(context));
                      }, child: const Text('отправить', style: TextStyle(color: Colors.white, fontSize: 14)))
                    ),
                  )
                : Padding(padding: const EdgeInsets.all(8), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,))),

            ],
          );
        }
      )
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

  int uiCheckQuantity(List cart, Map item) {
    int value = -1;
    if (cart.any((element) =>
        element.values.contains(item['category']) &&
        element.values.contains(item['name']) &&
        element.values.contains(item['color']) &&
        element.values.contains(item['producer']))) {
      for (var s in cart) {
        if (s['category'] == item['category'] &&
            s['name'] == item['name'] &&
            s['color'] == item['color'] &&
            s['producer'] == item['producer']) {
          value = item['quantity'] - int.parse(s['q_order']);
          break;
        } else {
          continue;
        }
      }
    } else {
      value = -1;
    }
    return value;
  }

  String uiGetComment(List cart, Map item){
    String comment = '';
    if (cart.any((element) =>
        element.values.contains(item['category']) &&
        element.values.contains(item['name']) &&
        element.values.contains(item['color']) &&
        element.values.contains(item['producer']))) {
      for (var s in cart) {
        if (s['category'] == item['category'] &&
            s['name'] == item['name'] &&
            s['color'] == item['color'] &&
            s['producer'] == item['producer']) {
          comment = s['comment'];
          break;
        } else {
          continue;
        }
      }
    } else {
      comment = '';
    }
    return comment;
  }
  

}