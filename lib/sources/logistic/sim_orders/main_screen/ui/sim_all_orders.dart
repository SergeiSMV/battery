


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


import '../../../../../static/ui/colors.dart';
import '../../selected_order/selected_order.dart';
import '../models/order_constructor.dart';

class SimAllOrders{
  final List allOrders;
  final BuildContext simOrdersContext;
  const SimAllOrders({required this.allOrders, required this.simOrdersContext});

  List get orders => allOrders;


  controller(){
    Function eq = const ListEquality().equals;
    List<dynamic> compare = ['search'];
    bool result = eq(allOrders, compare);
    
    return result ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,)) : 
      orders.isEmpty ? _emptyOrders() : _allOrdersViewer();
  }

  _allOrdersViewer(){
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: orders.length,
      itemBuilder: (context, index){
        
        orders.sort((a, b) {return a['status'].toString().compareTo(b['status'].toString());});
        OrderConstructor order = OrderConstructor(orderData: orders[index]);

        late Widget trailing;

        if (order.status == 0){ trailing = Icon(MdiIcons.bookmarkRemove, size: 30, color: Colors.red); }
        else if (order.status == 1) { trailing = Icon(MdiIcons.bookmarkPlus, size: 30, color: Colors.blue); }
        else if (order.status == 2) { trailing = Icon(MdiIcons.bookmarkMinus, size: 30, color: Colors.yellow); } 
        else { trailing = Icon(MdiIcons.bookmarkCheck, size: 30, color: Colors.green); }
    
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
                trailing: trailing,
                visualDensity: const VisualDensity(vertical: -4),
                tileColor: Colors.white,
                title: Text('Заявка № ${order.num}', style: TextStyle(fontSize: 12, color: firmColor)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('автор: ${order.customer}', style: const TextStyle(fontSize: 10),),
                    Text('создано: ${order.date} ${order.time}', style: const TextStyle(fontSize: 10),),
                  ],
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectedOrder(num: order.num,)));
                },
              ),
            )
          ),
        );
      }
    );
  }

  _emptyOrders(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200, width: 200,child: Lottie.asset('lib/images/lottie/not_found.json'),),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('заявки отсутствуют', textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 12, fontFamily: 'Montserrat')),
            ),
          ],
        ),
      ),
    );
  }

}