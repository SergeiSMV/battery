import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:collection/collection.dart';


import '../../../../../../../../static/ui/colors.dart';
import '../../../../../../static/api/api_routers.dart';
import '../../../../../../static/api/connection.dart';
import '../../../../../../static/models/bloc/is_tapped_bloc.dart';
import '../bloc/nomenclature_bloc.dart';
import '../bloc/nomenclatureadd_bloc.dart';
import 'addnomenclature_category.dart';
import 'addnomenclature_producer.dart';
import 'addnomenclature_unit.dart';


class AddNomenclarure{
  final BuildContext nomenclatureContext;
  final List currentState;
  const AddNomenclarure({required this.nomenclatureContext, required this.currentState});

  

  addNomenclarure(){
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: nomenclatureContext, 
      builder: (context){
        Map initBloc = {'category': '', 'name': '', 'producer': '', 'unit': '', 'box_size': '0x0x0', 'box_quant': '0'};
        return MultiBlocProvider(
          providers: [
            BlocProvider<NomenclatureAddBloc>(create: (context) => NomenclatureAddBloc()..add(NomenclatureAddChange(data: initBloc))),
            BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc()),
          ], 
          child: Builder(builder: (context){

            String category = context.watch<NomenclatureAddBloc>().state['category'].toString();
            String name = context.watch<NomenclatureAddBloc>().state['name'].toString();
            String producer = context.watch<NomenclatureAddBloc>().state['producer'].toString();
            // String palletWeight = context.watch<NomenclatureAddBloc>().state['pallet_weight'].toString();
            // String palletSize = context.watch<NomenclatureAddBloc>().state['pallet_size'].toString();
            // String boxWeight = context.watch<NomenclatureAddBloc>().state['box_weight'].toString();
            String boxSize = context.watch<NomenclatureAddBloc>().state['box_size'].toString();
            // String palletQuant = context.watch<NomenclatureAddBloc>().state['pallet_quant'].toString();
            String boxQuant = context.watch<NomenclatureAddBloc>().state['box_quant'].toString();
            String unit = context.watch<NomenclatureAddBloc>().state['unit'].toString();

            bool isTapped = context.watch<IsTappedBloc>().state;
            Map editState = context.watch<NomenclatureAddBloc>().state;


                       
            
            return editState.isEmpty ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,)) :
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                            Expanded(child: Text('создание номенклатуры', style: TextStyle(color: firmColor, fontSize: 16))),
                          ],
                        ),
                      )
                    ),
                  ),
                  
                  Flexible(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 5),

                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 25,),
                              Container(
                                decoration: BoxDecoration(color: mainColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                                  child: Text('1. Основные параметры', style: TextStyle(fontSize: 10, color: Colors.white),),
                                )
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade700, indent: 5, endIndent: 30,)),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: _enterValue('категория:', category, TextInputType.text, (value) { 
                                editState['category'] = value.toString();
                                context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                              },),),
                              IconButton(onPressed: (){
                                AddNomenclatureCategory(parrentContext: context, currentState: editState).getProducers();
                              }, icon: Icon(Icons.list_outlined, color: firmColor,)),
                              const SizedBox(width: 15,)
                            ],
                          ),

                          _enterValue('наименование:', name, TextInputType.text, (value) { 
                            editState['name'] = value.toString();
                            context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          },),

                          _itemElement('поставщик:', producer, 'укажите поставщика', () => AddNomenclatureProducer(currentState: editState, parrentContext: context).getProducers()),
                          _itemElement('ед. измерения:', unit, 'укажите ед. измерения', () => AddNomenclatureUnit(currentState: editState, parrentContext: context).getUnits()),


                          // const SizedBox(height: 20),
                          // Row(
                          //   children: [
                          //     const SizedBox(width: 25,),
                          //     Container(
                          //       decoration: BoxDecoration(color: mainColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                          //       child: const Padding(
                          //         padding: EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                          //         child: Text('2. Параметры паллета', style: TextStyle(fontSize: 10, color: Colors.white),),
                          //       )
                          //     ),
                          //     Expanded(child: Divider(color: Colors.grey.shade700, indent: 5, endIndent: 30,)),
                          //   ],
                          // ),
                          // _enterValue('высота паллета (мм):', palletSize.split('x')[0], TextInputType.text, (value) {
                          //   String height = value.toString();
                          //   String width = palletSize.split('x')[1];
                          //   String length = palletSize.split('x')[2];
                          //   editState['pallet_size'] = '${height}x${width}x$length';
                          //   context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          // },),
                          // _enterValue('ширина паллета (мм):', palletSize.split('x')[1], TextInputType.text, (value) {
                          //   String height = palletSize.split('x')[0];
                          //   String width = value.toString();
                          //   String length = palletSize.split('x')[2];
                          //   editState['pallet_size'] = '${height}x${width}x$length';
                          //   context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          // },),
                          // _enterValue('длина паллета (мм):', palletSize.split('x')[2], TextInputType.text, (value) {
                          //   String height = palletSize.split('x')[0];
                          //   String width = palletSize.split('x')[1];
                          //   String length = value.toString();
                          //   editState['pallet_size'] = '${height}x${width}x$length';
                          //   context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          // },),
                          // _enterValue('вес паллета (кг):', palletWeight, TextInputType.text, (value) { 
                          //   editState['pallet_weight'] = value.toString();
                          //   context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          // },),
                          // _enterValue('количество в паллете ($unit):', palletQuant, TextInputType.text, (value) { 
                          //   editState['pallet_quant'] = value.toString();
                          //   context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          // },),

                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 25,),
                              Container(
                                decoration: BoxDecoration(color: mainColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                                  child: Text('2. Параметры упаковки', style: TextStyle(fontSize: 10, color: Colors.white),),
                                )
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade700, indent: 5, endIndent: 30,)),
                            ],
                          ),

                          _enterValue('высота упаковки (мм):', boxSize.split('x')[0], TextInputType.text, (value) {
                            String height = value.toString();
                            String width = boxSize.split('x')[1];
                            String length = boxSize.split('x')[2];
                            editState['box_size'] = '${height}x${width}x$length';
                            context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          },),
                          _enterValue('ширина упаковки (мм):', boxSize.split('x')[1], TextInputType.text, (value) { 
                            String height = boxSize.split('x')[0];
                            String width = value.toString();
                            String length = boxSize.split('x')[2];
                            editState['box_size'] = '${height}x${width}x$length';
                            context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          },),
                          _enterValue('длина упаковки (мм):', boxSize.split('x')[2], TextInputType.text, (value) { 
                            String height = boxSize.split('x')[0];
                            String width = boxSize.split('x')[1];
                            String length = value.toString();
                            editState['box_size'] = '${height}x${width}x$length';
                            context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          },),
                          // _enterValue('вес упаковки (кг):', boxWeight, TextInputType.text, (value) { 
                          //   editState['box_weight'] = value.toString();
                          //   context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          // },),
                          _enterValue('количество в упаковке ($unit):', boxQuant, TextInputType.text, (value) { 
                            editState['box_quant'] = value.toString();
                            context.read<NomenclatureAddBloc>().add(NomenclatureAddChange(data: Map.from(editState)));
                          },),


                        ],
                      ),
                  ),

                  const SizedBox(height: 10),

                  category.isEmpty || name.isEmpty || producer.isEmpty || unit.isEmpty ? const SizedBox.shrink() :
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
                        await Connection(data: editState, route: simCreateNomenclature).connect().then((value){
                          value == 'done' ? 
                          {
                            currentState.add(editState),
                            nomenclatureContext.read<NomenclatureBloc>().add(NomenclatureChange(data: currentState.toList())), 
                            Navigator.pop(context)
                          } 
                          : null;
                        });
                      }, child: const Text('сохранить', style: TextStyle(color: Colors.white),))
                    )
                  : Padding(padding: const EdgeInsets.all(8), child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,))),
                  const SizedBox(height: 10),

                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.9),
                    child: const SizedBox(height: 5),
                  ),
                ],
              )
            );
          }),
        );
      }
    );
  }


  _itemElement(String leading, String blocText, String blocEmpty, Function func,){
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 35),
      child: GestureDetector(
        child: Container(
          height: 45,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(leading, style: TextStyle(color: firmColor, fontSize: 12)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(blocText.isEmpty ? blocEmpty : blocText, style: TextStyle(fontSize: 13, color: blocText.isEmpty ? Colors.grey : firmColor),)
              ),
            ],
          ),
        ),
        onTap: (){ func(); },
      ),
    );
  }



  _enterValue(String leading, String hint, TextInputType type, change){
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 8),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(leading, style: TextStyle(color: firmColor, fontSize: 12)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  readOnly: false,
                  keyboardType: type,
                  style: TextStyle(fontSize: 13, color: firmColor),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    hintStyle: TextStyle(fontSize: 13, color: firmColor, fontFamily: 'Montserrat'),
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