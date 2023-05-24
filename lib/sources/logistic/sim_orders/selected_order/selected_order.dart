
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../../../../../static/ui/colors.dart';
import '../../../../static/api/api_routers.dart';
import '../../../../static/api/connection.dart';
import '../../../../static/models/bloc/accesses_bloc.dart';
import '../../sim_storage/models/sim_elements.dart';
import 'appbar_selected_order.dart';
import 'bloc/selected_order_bloc.dart';
import 'item_order_tap.dart';


class SelectedOrder extends StatelessWidget {
  final String num;
  const SelectedOrder({Key? key, required this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SelectedOrderBloc>(create: (context) => SelectedOrderBloc(num: num)..add(GetSelectedOrderEvent())),
      ],
      child: Scaffold(
        appBar: const SelectedOrderAppBar().appBar(num),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            
            Expanded(
              child: BlocBuilder<SelectedOrderBloc, List>(
                builder: ((context, state) {

                  // SimAccesses userStatus = SimAccesses(blocState: context.watch<AccessesBloc>().state);
                  List accesses = context.watch<AccessesBloc>().state;
                  SimElements simElements = SimElements(blocState: accesses);

                  Function eq = const ListEquality().equals;
                  List<dynamic> compare = ['search'];
                  bool result = eq(state, compare);
                  return result ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,)) :
                  ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    late LinearGradient cardColor;
            
                    String name = '${state[index]['category']} ${state[index]['name']} ${state[index]['color']}';
                    String producer = state[index]['producer'];
                    String place = state[index]['place'];
                    String cell = state[index]['cell'];
                    int quantity = state[index]['quantity'];
                    String unit = state[index]['unit'];
                    int status = state[index]['status'];
                    String comment = state[index]['comment'];
                    String extradition = state[index]['fact_quant'] == 0 ? '' : state[index]['fact_quant'].toString();
                    // var chaptersAccess = context.watch<AccessesBloc>().state;


                    if (status == 0){ cardColor = redStatus; }
                    else if (status == 1) { cardColor = blueStatus; }
                    else if (status == 2) { cardColor = yellowStatus; } 
                    else { cardColor = greenStatus; }
            
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: cardColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                              visualDensity: const VisualDensity(vertical: -4),
                              tileColor: Colors.white,
                              title: Text(name, style: TextStyle(fontSize: 12, color: firmColor)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('поставщик: $producer', style: const TextStyle(fontSize: 10)),
                                  Text('местоположение: $place | $cell', style: const TextStyle(fontSize: 10)),
                                  Text('к выдаче:  $quantity $unit', style: const TextStyle(fontSize: 10)),
                                  extradition.isEmpty ? const SizedBox.shrink() : Text('выдано:  $extradition $unit', style: const TextStyle(fontSize: 10)),
                                  comment.isEmpty ? const SizedBox.shrink() : Text('комментарий:  $comment', style: const TextStyle(fontSize: 10)),
                                ],
                              ),
                              onTap: () {

                                simElements.soOut() ? 
                                  Connection(data: {'itemId': state[index]['item_id'].toString()}, route: simBaseItemQuantity).connect().then((value) { 
                                    value is int ? 
                                      {state[index]['baseItemQuantity'] = value, itemOrderTap(context, state[index], simElements)}
                                      : null;
                                  })
                                  // itemOrderTap(context, state[index], simElements) 
                                  :
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Нет доступа на выдачу комплектующих'), duration: Duration(seconds: 5),));
                              }),
                        )),
                    );
                  });
                })
              ),
            ),

          ],
        ),
      ),
    );
  }
}
