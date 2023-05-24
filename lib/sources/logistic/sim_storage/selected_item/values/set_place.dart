import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../../add_item/bloc/places_bloc.dart';
import '../bloc/itemreplace_bloc.dart';

String funcDescription = 'Выберите наименование склада, куда будет осуществленно перемещение.';

class SetPlace {
  final BuildContext parrentContext;
  const SetPlace({required this.parrentContext});

  getPlaces() {
    Connection(data: {}, route: simGetLocates).connect().then((value) => _checkResponce(value));
  }

  _checkResponce(dynamic responce) {
    if (responce is String) {
      return systemMessage(parrentContext, responce.toString(), 'lib/images/lottie/close.json');
    } else {
      parrentContext.read<PlacesBloc>().add(PlacesChange(data: responce));
      ProgressHUD.of(parrentContext)?.dismiss();
      return _setPlace(responce['locate']);
    }
  }

  _setPlace(List places) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: parrentContext,
      builder: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<ItemReplaceBloc>(parrentContext),
          child: Builder(
            builder: (context) {

              Map currentState = parrentContext.watch<ItemReplaceBloc>().state;

              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)), color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(child: Text(funcDescription, style: TextStyle(color: firmColor, fontSize: 12), textAlign: TextAlign.center)),
                      ),
                      const SizedBox(height: 5),

                      Divider(color: firmColor, indent: 30, endIndent: 30,),

                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: places.length,
                            itemBuilder: (contex, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                child: ListTile(
                                  visualDensity: const VisualDensity(vertical: -3),
                                  title: Text(places[index], textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 16)),
                                  onTap: () {
                                    currentState['place'] == places[index].toString() ? Navigator.pop(context) : 
                                    {
                                      currentState['place'] = places[index].toString(),
                                      currentState['cell'] = '',
                                      parrentContext.read<ItemReplaceBloc>().add(ItemReplaceChange(data: Map.from(currentState))),
                                      // ProgressHUD.of(parrentContext)?.dismiss(),
                                      Navigator.pop(context)
                                    };
                                  },
                                ),
                              );
                            }),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  )
                ),
              );
            }
          ),
        );
      }
    );
  }
}
