import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../bloc/itemedit_bloc.dart';

class SetUnit{
  final BuildContext itemEditContext;
  final Map currentState;
  const SetUnit({required this.itemEditContext, required this.currentState});
  

  getUnit() {
    currentState['name'].isEmpty ?
    {
      ProgressHUD.of(itemEditContext)?.dismiss(),
      systemMessage(itemEditContext, 'укажите наименование', 'lib/images/lottie/close.json')
    } :
    Connection(
      data: {
        'category': currentState['category'], 
        'name': currentState['name'], 
        'producer': currentState['producer']
      }, 
      route: simNmUnits).connect().then((value) => _checkResponce(value));
  }

  _checkResponce(dynamic responce){
    ProgressHUD.of(itemEditContext)?.dismiss();
    if(responce is String){
      return systemMessage(itemEditContext, responce.toString(), 'lib/images/lottie/close.json');
    } else {
      return _setUnit(responce);
    }
  }

  _setUnit(List units){
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: itemEditContext, 
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
              Text('выбирите единицу измерения', style: TextStyle(color: firmColor, fontSize: 12), textAlign: TextAlign.center,),
              const SizedBox(height: 5),

              Divider(color: firmColor, indent: 30, endIndent: 30,),

              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: units.length,
                    itemBuilder: (contex, index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -3),
                          title: Text(units[index], textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 16)),
                          onTap: (){
                            currentState['unit'] == units[index].toString() ? null : {
                              currentState['unit'] = units[index].toString(),
                              itemEditContext.read<ItemEditBloc>().add(ItemEditChange(data: Map.from(currentState))),
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