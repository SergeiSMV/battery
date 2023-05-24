import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../../../static/ui/colors.dart';
import '../../bloc/isexpanded_bloc.dart';
import '../bloc/itemhistory_bloc.dart';




class ItemHistory{
  final Map data;
  final BuildContext itemInfoRouterContext;
  const ItemHistory({Key? key, required this.data, required this.itemInfoRouterContext});

  getHistoryList() {
    List history = itemInfoRouterContext.watch<ItemHistoryBloc>().state;
    return Builder(
      builder: (context) {
        history.sort((a, b) {return b['id'].compareTo(a['id']);});
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          
              const SizedBox(height: 10),
          
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 40,),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){ context.read<IsExpandedBloc>().add(IsExpandedChange()); }, 
                        icon: Icon(MdiIcons.closeCircle, color: firmColor),
                        iconSize: 25,
                      ),
                      Expanded(child: SizedBox(width: double.infinity, child: Text('История позиции', style: TextStyle(color: firmColor, fontSize: 16), textAlign: TextAlign.left,))),
                    ],
                  ),
                ),
              ),
          
              // ignore: unnecessary_null_comparison
              history == null ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,)) 
              :
              history.isNotEmpty ? 
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 40, bottom: 8),
                    child: SizedBox(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: history.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(history[index]['action'], style: TextStyle(color: firmColor, fontSize: 12),),
                                history[index]['comment'] == '' ? const SizedBox.shrink() :
                                  Text('${history[index]['comment']}', style: TextStyle(color: firmColor, fontSize: 10), textAlign: TextAlign.left,),
                                Text('${history[index]['date']} - ${history[index]['author']}', style: TextStyle(color: firmColor, fontSize: 10), textAlign: TextAlign.left,),
                              ]
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ) 
                : 
                Center(child: Text('нет данных', style: TextStyle(color: firmColor),),),
                const SizedBox(height: 10),
            ],
          ),
        );
      }
    );
  }
}
