import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/ui/colors.dart';
import '../../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../../static/ui/system_message.dart';
import 'bloc/item_comment_bloc.dart';
import 'bloc/item_quantity_bloc.dart';
import 'bloc/order_cart_bloc.dart';


class OrderDialog {
  BuildContext mainContext;
  final Map item;
  final int remainder;
  OrderDialog({required this.mainContext, required this.item, required this.remainder});

  dialog() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: mainContext,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ItemQuantityBloc>(create: (context) => ItemQuantityBloc()),
            BlocProvider<ItemCommentBloc>(create: (context) => ItemCommentBloc()),
            BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc()),
          ],
          child: Builder(builder: (context) {

            String quantity = context.watch<ItemQuantityBloc>().state;
            String comment = context.watch<ItemCommentBloc>().state;
            bool isTapped = context.watch<IsTappedBloc>().state;
            List savedCart = mainContext.read<OrderCartBloc>().state;

            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text('${item['category']} ${item['name']} ${item['color']}', style: TextStyle(fontSize: 14, color: firmColor)),
                  Text('поставщик: ${item['producer']}', style: TextStyle(fontSize: 12, color: firmColor)),
                  Text('доступно: $remainder ${item['unit']}', style: TextStyle(fontSize: 12, color: firmColor)),
                  Divider(color: firmColor, indent: 15, endIndent: 15, height: 30, thickness: 1),
                  Text('укажите нужное количество и комментарий при необходимости:', style: TextStyle(fontSize: 12, color: firmColor), textAlign: TextAlign.center,),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 10),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 13, color: firmColor),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontFamily: 'Montserrat'),
                          hintText: 'укажите количество',
                          prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF78909C)), child: Icon(Icons.onetwothree, size: 25)),
                        ),
                        onChanged: (value) {
                          context.read<ItemQuantityBloc>().add(ItemQuantityChangeEvent(data: value));
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 10,),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 13, color: firmColor),
                        minLines: 1,
                        maxLines: 5,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontFamily: 'Montserrat'),
                          hintText: 'комментарий',
                          prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF78909C)), child: Icon(Icons.edit, size: 20)),
                        ),
                        onChanged: (value) {
                          context.read<ItemCommentBloc>().add(ItemCommentChangeEvent(data: value));
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  quantity.isEmpty ? const SizedBox.shrink() : 
                    isTapped == false ?
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(color: mainColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                          child: TextButton(onPressed: (){
                            context.read<IsTappedBloc>().add(IsTappedChangeEvent());
                            List cart = savedCart;
                            Map itemOrder = {
                              'category': item['category'],
                              'name': item['name'],
                              'color': item['color'],
                              'producer': item['producer'],
                              'q_order': quantity,
                              'comment': comment
                            };
                            int.parse(quantity) > remainder ? {
                              systemMessage(mainContext, 'превышен допустимый остаток', 'lib/images/lottie/close.json'),  
                              context.read<IsTappedBloc>().add(IsTappedChangeEvent())
                            }
                            :
                            {
                              orderCheckDuplicate(cart, itemOrder) ? null : cart.add(itemOrder),
                              mainContext.read<OrderCartBloc>().add(OrderCartChangeEvent(data: cart.toList())),
                              Navigator.pop(context)
                            };
                          }, child: const Text('подтвердить', style: TextStyle(color: Colors.white, fontSize: 12)))
                        ),
                      )
                    : Padding(padding: const EdgeInsets.all(8), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,))),
                  
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const SizedBox(height: 10),
                  ),
                ],
              ),
            );
          }),
        );
      }
    );
  }


  bool orderCheckDuplicate(List cart, Map orderData) {
    bool result = false;
    if (cart.any((element) =>
        element.values.contains(orderData['category']) &&
        element.values.contains(orderData['name']) &&
        element.values.contains(orderData['color']) &&
        element.values.contains(orderData['producer']))) {
      for (var s in cart) {
        if (s['category'] == orderData['category'] &&
            s['name'] == orderData['name'] &&
            s['color'] == orderData['color'] &&
            s['producer'] == orderData['producer']) {
          s['q_order'] = (int.parse(orderData['q_order']) + int.parse(s['q_order'])).toString();
          result = true;
          break;
        } else {
          continue;
        }
      }
    } else {
      result = false;
    }
    return result;
  }


}
