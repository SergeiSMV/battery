import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../bloc/additem_bloc.dart';

class AddItemName{
  final BuildContext parrentContext;
  final Map currentState;
  final List controllers;
  const AddItemName({required this.parrentContext, required this.currentState, required this.controllers});


  getNames() {
    currentState['category'].isEmpty ? 
    {
      ProgressHUD.of(parrentContext)?.dismiss(),
      systemMessage(parrentContext, 'заполните поля выше', 'lib/images/lottie/close.json')
    } :
    Connection(data: {'category': currentState['category']}, route: simNmNames).connect().then((value) => _checkResponce(value));
  }

  _checkResponce(dynamic responce){
    ProgressHUD.of(parrentContext)?.dismiss();
    if(responce is String){
      return systemMessage(parrentContext, responce.toString(), 'lib/images/lottie/close.json');
    } else {
      return _setName(responce);
    }
  }

  _setName(List names){
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: parrentContext, 
      builder: (context){
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
            color: Colors.white
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text('выберите наименование', style: TextStyle(color: firmColor, fontSize: 12), textAlign: TextAlign.center,),
              const SizedBox(height: 5),

              Divider(color: firmColor, indent: 30, endIndent: 30,),
              
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: names.length,
                    itemBuilder: (contex, index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -3),
                          title: Text(names[index], textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 16)),
                          onTap: (){
                            currentState['name'] == names[index].toString() ? null : {
                              currentState['name'] = names[index].toString(),
                              currentState['color'] = '',
                              currentState['producer'] = '',
                              currentState['unit'] = '',
                              currentState['box_size'] = '0x0x0',
                              currentState['base_box_size'] = '',
                              currentState['pallet_row'] = '0',
                              currentState['pallet_quantity'] = '0',
                              currentState['quantity'] = '0',
                              for (var n in controllers){ n.clear() },
                              parrentContext.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState))),
                            }; 
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    );
  }

}