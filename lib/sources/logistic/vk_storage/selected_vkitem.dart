import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../static/ui/colors.dart';
import '../../../../../static/api/api_routers.dart';
import '../../../../../static/api/connection.dart';
import '../../../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../static/ui/system_message.dart';
import '../../accounts/models/checkbox_color.dart';
import 'vk_storage_bloc/vkdocument_bloc.dart';


class SelectedVkItem{
  final BuildContext vkAllItemsContext;
  final List currentState;
  final int index;
  const SelectedVkItem({required this.vkAllItemsContext, required this.currentState, required this.index});

  

  selectedItem(){
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: vkAllItemsContext, 
      builder: (context){
        Map initDocuments = {'documents': 'укажите номер и дату документа', 'status': 'work', 'quantity': '0'};
        return MultiBlocProvider(
          providers: [
            BlocProvider<VkDocumentsBloc>(create: (context) => VkDocumentsBloc()..add(VkDocumentsChange(data: Map.from(initDocuments)))),
            BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc()),
          ], 
          child: Builder(
            builder: (context){
              
              bool isTapped = context.watch<IsTappedBloc>().state;
              String document = context.watch<VkDocumentsBloc>().state['documents'].toString();
              String status = context.watch<VkDocumentsBloc>().state['status'].toString();
              String quantity = context.watch<VkDocumentsBloc>().state['quantity'].toString();

              Map documentsState = context.watch<VkDocumentsBloc>().state;
              
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

                    const SizedBox(height: 20),
                    Center(child: Text('входной контроль', style: TextStyle(color: firmColor, fontSize: 16)),),
                    const SizedBox(height: 5),
                    Divider(color: Colors.grey.shade700, indent: 30, endIndent: 30,),
                    const SizedBox(height: 20),

                    _enterValue('документ:', document, TextInputType.text, (value) {
                      documentsState['documents'] = value.toString();
                      context.read<VkDocumentsBloc>().add(VkDocumentsChange(data: Map.from(documentsState)));
                    },),

                    _enterValue('количество:', quantity, TextInputType.number, (value) {
                      documentsState['quantity'] = value.toString();
                      context.read<VkDocumentsBloc>().add(VkDocumentsChange(data: Map.from(documentsState)));
                    },),

                    _checkbox(context, documentsState),

                    const SizedBox(height: 10),

                    document == 'укажите номер и дату документа' || quantity == '0' ? const SizedBox.shrink() :
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
                          int.parse(quantity.toString()) > int.parse(currentState[index]['quantity'].toString()) ? 
                          { systemMessage(context, 'превышен допустимый остаток!', 'lib/images/lottie/close.json'), context.read<IsTappedBloc>().add(IsTappedChangeEvent()) } :
                          currentState[index]['document'] = document;
                          currentState[index]['status'] = status;
                          currentState[index]['quantity_move'] = quantity;
                          await Connection(data: currentState[index], route: vkItemMove).connect().then((value){
                            value == 'done' ? 
                            {
                              context.read<IsTappedBloc>().add(IsTappedChangeEvent()),
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

  _checkbox(BuildContext context, Map documentsState) {
    bool value = documentsState['status'] == 'stop' ? true : false;
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(checkBoxColor),
              value: value,
              onChanged: (bool? value) {
                value! ? documentsState['status'] = 'stop' : documentsState['status'] = 'work';
                context.read<VkDocumentsBloc>().add(VkDocumentsChange(data: Map.from(documentsState)));
              }
            ),
          ),
          Text('брак', style: TextStyle(fontSize: 12, fontFamily: 'Montserrat', color: firmColor))
        ],
      ),
    );
  }



  _enterValue(String leading, String hint, TextInputType type, change){
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 8),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(leading, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  readOnly: false,
                  keyboardType: type,
                  style: TextStyle(fontSize: 14, color: firmColor),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    hintStyle: TextStyle(fontSize: 14, color: firmColor, fontFamily: 'Montserrat'),
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