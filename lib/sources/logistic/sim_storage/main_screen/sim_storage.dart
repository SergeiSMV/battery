import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/models/bloc/accesses_bloc.dart';
import '../../logistic_drawer.dart';
import '../../sort_department_elements.dart';
import '../selected_item/bloc/itemid_bloc.dart';
import '../bloc/isexpanded_bloc.dart';
import 'allitems.dart';
import '../selected_item/selected_item.dart';
import 'bloc/allitems_bloc.dart';
import 'storage_searchbar.dart';
import 'storage_appbar.dart';
import 'storage_menu.dart';

class SimStorage extends StatelessWidget {
  const SimStorage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AllItemsBloc>(create: (context) => AllItemsBloc()..add(GetSimAllItemsEvent())),
        BlocProvider<ItemIdBloc>(create: (context) => ItemIdBloc()),
        BlocProvider<IsExpandedBloc>(create: (context) => IsExpandedBloc()),
      ],
      child: Builder(
        builder: (context) {
          
          List accesses = context.watch<AccessesBloc>().state;
          List elements = sortDepartmentElements(accesses, 'logistic');
          final scaffoldKey = GlobalKey<ScaffoldState>();
          bool searchBarExpanded = context.watch<IsExpandedBloc>().state;
          
          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: StorageAppbar(scaffoldKey: scaffoldKey).appBar(),
            drawerEnableOpenDragGesture: false,
            drawer: LogisticDrawer(context: context, accesses: accesses, departmentElements: elements).drawer(),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Container(height: 50, color: Colors.green.shade200, child: storageMenu(context, accesses)),
                // Container(height: 40, color: Colors.blue, child: storageMenu(contextBuilder, accesses)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: searchBarExpanded ? const StorageSearchBar() : const SizedBox.shrink(),
                ),
      
                Expanded(
                  child: BlocConsumer<AllItemsBloc, List>(
                    builder: ((context, state){
                      return AllItems(allItemsState: state, allItemsContext: context).controller();
                    }), 
                    listener: ((context, state){
                      state.length == 1 && state[0] != 'load' ? 
                        {
                          context.read<ItemIdBloc>().add(ItemIdChange(itemId: state[0]['itemId'])),
                          SelectedItem(allItemsContext: context).selectedItem().whenComplete(() { context.read<AllItemsBloc>().add(SimStorageClearSearchEvent()); })
                        }
                        : null;
                    }),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
