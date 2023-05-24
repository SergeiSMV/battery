import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/models/bloc/accesses_bloc.dart';
import '../../../logistic_drawer.dart';
import '../../../sort_department_elements.dart';
import '../bloc/sim_all_orders_bloc.dart';
import 'sim_all_orders.dart';
import 'sim_orders_appbar.dart';
import 'sim_orders_menu.dart';

class SimOrders extends StatelessWidget {
  const SimOrders({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SimAllOrdersBloc>(create: (context) => SimAllOrdersBloc()..add(GetSimAllOrdersEvent())),        
      ],
      child: Builder(
        builder: (context) {

          final scaffoldKey = GlobalKey<ScaffoldState>();
          List accesses = context.watch<AccessesBloc>().state;
          List elements = sortDepartmentElements(accesses, 'logistic');

          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: SimOrdersAppbar(scaffoldKey: scaffoldKey).appBar(),
            drawerEnableOpenDragGesture: false,
            drawer: LogisticDrawer(context: context, accesses: accesses, departmentElements: elements).drawer(),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 50, color: Colors.green.shade200, child: simOrdersMenu(context, accesses)),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<SimAllOrdersBloc, List>(
                    builder: ((context, state) {
                      return SimAllOrders(allOrders: state, simOrdersContext: context).controller();
                    })
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
