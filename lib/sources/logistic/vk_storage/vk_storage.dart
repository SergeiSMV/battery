import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../static/models/bloc/accesses_bloc.dart';
import 'vk_storage_bloc/vkallitems_bloc.dart';
import '../sort_department_elements.dart';
import '../logistic_drawer.dart';
import 'vk_appbar.dart';
import 'vkallitems.dart';

class VkStorage extends StatelessWidget {
  const VkStorage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VkAllItemsBloc>(create: (context) => VkAllItemsBloc()..add(GetVkAllItemsEvent())),
        // BlocProvider<ItemIdBloc>(create: (context) => ItemIdBloc()),
        // BlocProvider<IsExpandedBloc>(create: (context) => IsExpandedBloc()),
      ],
      child: Builder(
        builder: (contextBuilder) {
          
          List accesses = contextBuilder.watch<AccessesBloc>().state;
          List elements = sortDepartmentElements(accesses, 'logistic');
          final scaffoldKey = GlobalKey<ScaffoldState>();
          
          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: VkAppbar(scaffoldKey: scaffoldKey).appBar(),
            drawerEnableOpenDragGesture: false,
            drawer: LogisticDrawer(context: contextBuilder, accesses: accesses, departmentElements: elements).drawer(),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const SizedBox(height: 5),

                Expanded(
                  child: BlocBuilder<VkAllItemsBloc, List>(
                    builder: ((context, state){
                      return VkAllItems(allItemsContext: context, allItemsState: state).controller();
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
