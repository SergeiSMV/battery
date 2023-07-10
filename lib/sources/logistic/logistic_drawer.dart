import 'package:battery/static/api/connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../static/models/unlogin.dart';
import '../../../static/ui/colors.dart';
import 'sim_storage/bloc/logistic_router_bloc.dart';

class LogisticDrawer{
  final BuildContext context;
  final List accesses;
  final List departmentElements;
  const LogisticDrawer({required this.context, required this.accesses, required this.departmentElements});

  drawer(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ..._drawerElements()
          ],
        ),
      ),
    );
  }

  _drawerElements(){
    List elements = [];

    elements.add(_drawerHeader());
    
    for (var e in departmentElements){
      elements.add(ListTile(title: Text('${e['description']}', textAlign: TextAlign.center,), onTap: (){ context.read<LogisticRouterBloc>().add(LogisticRouterChange(index: e['index'])); },));
    }

    elements.add(const SizedBox(height: 30,));
    elements.add(Divider(height: 1, endIndent: 30, indent: 30, color: firmColor,));
    elements.add(const SizedBox(height: 30,));
    // elements.add(ListTile(title: const Text('личный кабинет', textAlign: TextAlign.center,), onTap: (){  },));
    elements.add(ListTile(title: const Text('выйти из аккаунта', textAlign: TextAlign.center,), onTap: (){ unlogin(context); },));

    elements.add(TextButton(onPressed: (){
      Connection(route: 'sim_load_items').connect();
    }, child: const Text('upload')));

    return elements;

  }

  _drawerHeader(){
    return SizedBox(
      height: 130,
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.green.shade100,
        ),
        child: Center(
          child: Text('меню навигации\r\nдепартамента логистики', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: firmColor),)),
      ),
    );
  }


}