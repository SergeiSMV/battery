import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../bloc/additem_bloc.dart';

class AddItemColor{
  final BuildContext parrentContext;
  final Map currentState;

  const AddItemColor({required this.parrentContext, required this.currentState});

  getColors() {
    currentState['category'].isEmpty || currentState['name'].isEmpty || currentState['producer'].isEmpty ?
    {
      ProgressHUD.of(parrentContext)?.dismiss(),
      systemMessage(parrentContext, 'заполните поля выше', 'lib/images/lottie/close.json')
    } :
    Connection(data: {}, route: simGetColors).connect().then((value) => _checkResponce(value));
  }

  _checkResponce(dynamic responce){
    ProgressHUD.of(parrentContext)?.dismiss();
    if(responce is String){
      return systemMessage(parrentContext, responce.toString(), 'lib/images/lottie/close.json');
    } else {
      return _setColor(responce);
    }
  }

  _setColor(List colors){
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
              Text('выбирите цвет', style: TextStyle(color: firmColor, fontSize: 12), textAlign: TextAlign.center,),
              const SizedBox(height: 5),

              Divider(color: firmColor, indent: 30, endIndent: 30,),

              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: colors.length,
                    itemBuilder: (contex, index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -3),
                          title: Text(colors[index], textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 16)),
                          onTap: (){
                            currentState['color'] == colors[index].toString() ? null : {
                              currentState['color'] = colors[index].toString(),
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