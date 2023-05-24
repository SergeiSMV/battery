




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../static/ui/colors.dart';
import 'appbar_sim_add_order.dart';
import 'bloc/sim_uniq_items_bloc.dart';
import 'search_uniq_items.dart';
import 'sim_uniq_items.dart';

class SimAddOrder extends StatelessWidget {
  const SimAddOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SimUniqBloc>(create: (context) => SimUniqBloc()..add(GetSimUniqEvent())),
      ], 
      child: Builder(
        builder: (context){
          return Scaffold(
            appBar: const SimAddOrderAppBar().appBar(),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SearchUniqItems(),
                Divider(color: firmColor, indent: 30, endIndent: 30,),
                Flexible(
                  child: BlocBuilder<SimUniqBloc, List>(
                    builder: ((context, state) {
                      return SimUniqItems(addOrderContext: context, uniqItems: state).controller();
                    })
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }
}