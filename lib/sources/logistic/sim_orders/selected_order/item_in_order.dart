import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../static/ui/colors.dart';
import '../../../../static/api/api_routers.dart';
import '../../../../static/api/connection.dart';
import '../../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../../static/ui/system_message.dart';
import 'bloc/base_item_quantity_bloc.dart';
import 'bloc/quantity_bloc.dart';

String funcDescription = ''' 
  Укажите фактическое количество,
  которе выдано с текущего места хранения.
  ''';

itemInOrder(BuildContext mainContext, Map orderItem){
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: mainContext, 
    builder: (context){
      
      return MultiBlocProvider(
        providers: [
          BlocProvider<BaseItemQuantBloc>(create: (context) => BaseItemQuantBloc()),
          BlocProvider<QuantityBloc>(create: (context) => QuantityBloc()),
          BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc()),
        ], 
        child: Builder(builder: (context){
          int baseItemQuantity = orderItem['baseItemQuantity'];
          String orderItemQuantity = context.watch<QuantityBloc>().state;
          bool isTapped = context.watch<IsTappedBloc>().state;
          return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                color: Colors.blue.shade100,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                        color: mainColor,
                      ),
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Text('${orderItem['category']} ${orderItem['name']} ${orderItem['color']}', style: const TextStyle(color: Colors.white, fontSize: 12)))
                    ),

                    const SizedBox(height: 10),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(funcDescription, style: TextStyle(color: firmColor, fontSize: 10), textAlign: TextAlign.center,),
                    ),
                    
                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text('к выдаче: ${orderItem['quantity']} ${orderItem['unit']}', style: TextStyle(color: firmColor, fontSize: 12), textAlign: TextAlign.center,),
                    ),
                    
                    const SizedBox(height: 10),

                    enterValue('выдано:', orderItemQuantity, TextInputType.number, (value) { context.read<QuantityBloc>().add(QuantityChangeEvent(data: value)); },),

                    const SizedBox(height: 10),

                    orderItemQuantity.isEmpty ? const SizedBox.shrink() :
                    isTapped == false ?
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            color: mainColor,
                          ),
                          height: 35,
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(onPressed: () async {
                            Map extraditionData = {'order_id': orderItem['order_id'], 'num': orderItem['num'], 'factQuantity': orderItemQuantity};
                            context.read<IsTappedBloc>().add(IsTappedChangeEvent());
                            int.parse(orderItemQuantity) > baseItemQuantity ? 
                              {systemMessage(mainContext, 'превышен допустимый остаток!', 'lib/images/lottie/close.json'), context.read<IsTappedBloc>().add(IsTappedChangeEvent())} 
                              :
                              {
                                await Connection(data: extraditionData, route: simItemExtradition).connect().then((value){
                                  value == 'done' ? Navigator.pop(context) : null;
                                })
                              };
                          }, child: const Text('выдать', style: TextStyle(color: Colors.white),))
                        ),
                      )
                    : Padding(padding: const EdgeInsets.all(8), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,))),

                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const SizedBox(height: 5),
                    ),
                  ],
                )
              )
          );
        })
      );
    });
}


enterValue(String leading, String hint, TextInputType type, change){
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8),
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