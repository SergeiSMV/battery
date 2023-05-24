import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/models/bloc/is_tapped_bloc.dart';
import 'bloc/newproducers_bloc.dart';
import 'bloc/producers_bloc.dart';


class AddProducers{
  final BuildContext producersContext;
  final List currentState;
  const AddProducers({required this.producersContext, required this.currentState});

  

  addProducers(){
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: producersContext, 
      builder: (context){
        return MultiBlocProvider(
          providers: [
            BlocProvider<NewProducersBloc>(create: (context) => NewProducersBloc()),
            BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc()),
          ], 
          child: Builder(
            builder: (context){
              
              bool isTapped = context.watch<IsTappedBloc>().state;
              String producer = context.watch<NewProducersBloc>().state;
              
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(onTap: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back, color: firmColor,),),
                              const SizedBox(width: 30),
                              Expanded(child: Text('добавление поставщика', style: TextStyle(color: firmColor, fontSize: 16))),
                            ],
                          ),
                        )
                      ),
                    ),

                    _enterValue('поставщик:', producer, TextInputType.text, (value) {
                      context.read<NewProducersBloc>().add(NewProducersChange(data: value.toString()));
                    },),

                    const SizedBox(height: 10),

                    isTapped == false ?
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Color(0xFF2156a8),
                        ),
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.87,
                        child: TextButton(onPressed: () async {
                          context.read<IsTappedBloc>().add(IsTappedChangeEvent());
                          await Connection(data: {'producer': producer}, route: simCreateProducers).connect().then((value){
                            value == 'done' ? 
                            {
                              currentState.add({'producer': producer}),
                              producersContext.read<ProducersBloc>().add(ProducersChange(data: currentState.toList())), 
                              Navigator.pop(context)
                            } 
                            : null;
                          });
                        }, child: const Text('сохранить', style: TextStyle(color: Colors.white),))
                      )
                    : Padding(padding: const EdgeInsets.all(8), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,))),
                    const SizedBox(height: 10),

                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const SizedBox(height: 5),
                    ),
                  ],
                )
              );
            }
          ),
        );
      }
    );
  }



  _enterValue(String leading, String hint, TextInputType type, change){
    return Padding(
      padding: const EdgeInsets.only(left: 63, right: 8),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(leading, style: TextStyle(color: firmColor, fontSize: 14)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  readOnly: false,
                  keyboardType: type,
                  style: TextStyle(fontSize: 16, color: firmColor),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    hintStyle: TextStyle(fontSize: 16, color: firmColor, fontFamily: 'Montserrat'),
                    hintText: hint,
                  ),
                  onChanged: (value){ change(value); },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}