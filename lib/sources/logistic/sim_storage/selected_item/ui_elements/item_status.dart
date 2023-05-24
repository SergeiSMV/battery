import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/ui/system_message.dart';
import '../../bloc/isexpanded_bloc.dart';
import '../bloc/itemstatus_bloc.dart';

String funcDescription = 'Данная функция позволяет изменить статус ТМЦ. Вы можете приостановить движение или возобновить его. ' 
  'Любое изменение должно быть на чём-то основано, это могут быть акт о браке продукции или распоряжение на выдачу. Для изменения '
  'статуса введите номер документа и его дату в форму ниже.';


class ItemStatus {
  final Map data;
  final BuildContext itemInfoRouterContext;
  const ItemStatus({Key? key, required this.data, required this.itemInfoRouterContext});

  changeItemStatus() {
    return BlocProvider<ItemStatusBloc>(
      create: (context) => ItemStatusBloc(),
      child: ProgressHUD(
        barrierColor: Colors.white.withOpacity(0.7),
        child: Builder(
          builder: (context) {
            var authorData = GetStorage().read('info');
            String author = '${authorData['surname']} ${authorData['name'][0]}.${authorData['patronymic'][0]}.';
            String statusBloc = context.watch<ItemStatusBloc>().state;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
      
                  const SizedBox(height: 10),
            
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 40,),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){ context.read<IsExpandedBloc>().add(IsExpandedChange()); }, 
                          icon: Icon(MdiIcons.closeCircle, color: firmColor),
                          iconSize: 25,
                        ),
                        Expanded(child: SizedBox(width: double.infinity, child: Text('Изменение статуса позиции', style: TextStyle(color: firmColor, fontSize: 16), textAlign: TextAlign.left,))),
                      ],
                    ),
                  ),
            
                  // ignore: deprecated_member_use
                  WidgetsBinding.instance.window.viewInsets.bottom > 0.0 ? const SizedBox.shrink() : Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8),
                    child: SizedBox(child: Text(funcDescription, style: TextStyle(color: firmColor, fontSize: 12), textAlign: TextAlign.justify,)),
                  ),
                  const SizedBox(height: 10),
            
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 13, color: firmColor),
                        minLines: 1,
                        maxLines: 5,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontFamily: 'Montserrat'),
                          hintText: 'укажите номер и дату документа',
                          prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF78909C)), child: Icon(Icons.my_library_books_sharp, size: 20,)),
                        ),
                        onChanged: (value){ context.read<ItemStatusBloc>().add(ItemStatusChange(data: value)); },
                      ),
                    ),
                  ),
            
                  statusBloc.isEmpty || statusBloc.length < 10 ? const SizedBox.shrink() : const SizedBox(height: 10),
            
                  statusBloc.isEmpty || statusBloc.length < 10 ? const SizedBox.shrink() : 
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.blue.shade400,
                      ),
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextButton(onPressed: () async {
                        ProgressHUD.of(context)?.showWithText('меняем статус');
                        String newStatus = data['status'] == 'work' ? 'stop' : 'work';
                        Map statusData = {'itemId': data['itemId'], 'author': author.toString(), 'status': newStatus, 'comment': statusBloc};
                        await Connection(data: statusData, route: simChangeStatus).connect().then((value){
                          ProgressHUD.of(context)?.dismiss();
                          value == 'done' ? context.read<IsExpandedBloc>().add(IsExpandedChange()) :
                          systemMessage(context, value, 'lib/images/lottie/close.json');
                        });
                      }, child: const Text('подтвердить', style: TextStyle(color: Colors.white),))
                    ),
                  
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.85),
                    child: const SizedBox(height: 0),
                  ),
      
                  const SizedBox(height: 10),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

}
