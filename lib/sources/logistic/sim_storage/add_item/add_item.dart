import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../static/models/bloc/accesses_bloc.dart';
import '../../../../../static/ui/calendar.dart';
import '../../../../../static/ui/colors.dart';
import '../../../../../static/ui/scanner.dart';
import '../models/sim_elements.dart';
import 'additem_appbar.dart';
import 'bloc/additem_bloc.dart';
import 'bloc/places_bloc.dart';
import 'models/barcode_autofill.dart';
import 'models/check_fills.dart';
import 'models/init_author.dart';
import 'models/init_boxsize.dart';
import 'models/init_date.dart';
import 'models/init_unit.dart';
import 'models/items_exceptions.dart';
import 'ui/description.dart';
import 'models/item_element.dart';
import 'ui/main_options.dart';
import 'ui/pallet_checkbox.dart';
import 'ui/place_options.dart';
import 'ui/quantity_options.dart';
import 'ui/submit.dart';


class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  Map init = {
    'category': '', 'name': '', 'producer': '', 'color': '', 'barcode': '', 'unit': '',
    'box_size': '0x0x0', 'box_quantity': '0', 'base_box_size': '', 'base_box_quantity': '', 'pallet_row': '0', 'pallet_quantity': '0', 'quantity': '0', 
    'place': '', 'cell': '', 'fifo': '', 'author': '', 'pallet_size': 'standart',
  };
  TextEditingController heightCntrlr = TextEditingController();
  TextEditingController widthCntrlr = TextEditingController();
  TextEditingController lengthCntrlr = TextEditingController();
  TextEditingController boxQuantityCntrl = TextEditingController();
  TextEditingController rowQuantityCntrlr = TextEditingController();
  TextEditingController palletQuantityCntrlr = TextEditingController();
  TextEditingController totalQuantityCntrlr = TextEditingController();

  List<TextEditingController> controllers = [];

  @override
  void initState(){
    controllers = [heightCntrlr, widthCntrlr, lengthCntrlr, boxQuantityCntrl, rowQuantityCntrlr, palletQuantityCntrlr, totalQuantityCntrlr]; 
    super.initState();
  }

  @override
  void dispose(){
    heightCntrlr.clear(); heightCntrlr.dispose();
    widthCntrlr.clear(); widthCntrlr.dispose();
    lengthCntrlr.clear(); lengthCntrlr.dispose();
    rowQuantityCntrlr.clear(); rowQuantityCntrlr.dispose();
    palletQuantityCntrlr.clear(); palletQuantityCntrlr.dispose();
    totalQuantityCntrlr.clear(); totalQuantityCntrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddItemBloc>(create: (context) => AddItemBloc()..add(AddItemChange(data: init))),
        BlocProvider<PlacesBloc>(create: (context) => PlacesBloc()),
      ],
      child: ProgressHUD(
        child: Builder(
          builder: (context) {
            
            List accesses = context.watch<AccessesBloc>().state;
            SimElements simElements = SimElements(blocState: accesses);
        
            String date = context.watch<AddItemBloc>().state['fifo'].toString();
        
            Map currentState = context.watch<AddItemBloc>().state;
        
            initDate(context, currentState);
            initAuthor(context, currentState);
            initUnit(context, currentState);
            initBoxSize(context, currentState);
              
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: const AddItemAppBar().appBar(),
              
              body: ProgressHUD(
                barrierColor: Colors.white.withOpacity(0.7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    description(),
                    
                    const SizedBox(height: 5,),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TextButton.icon(onPressed: (){ Scanner(mainContext: context, hint: '', func: (scanContext, value){barcodeAutoFill(context, value, currentState, controllers);}).scann();},
                      icon: Icon(MdiIcons.barcode, color: firmColor, size: 25,), label: Text('заполнить по штрих коду', style: TextStyle(color: firmColor, fontSize: 12),)),
                    ),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            mainOptions(context, currentState, controllers),
                            quantityOptions(context, currentState, controllers),
                            
                            // currentState['pallet_quantity'] != '' || currentState['quantity'] != '' ?
                            //   const SizedBox.shrink() :
                            //     currentState['pallet_quantity'] == currentState['quantity'] ?
                            //     simElements.ssaPlace() ? placeOptions(context, currentState) : const SizedBox.shrink()
                            //     :
                            //     const SizedBox.shrink(),

                            simElements.ssaPlace() ? placeOptions(context, currentState) : const SizedBox.shrink(),
                            
                            const SizedBox(height: 5),
                    
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: itemElement('дата:', date, 'укажите дату поступления', () {
                                    simElements.ssaDate() ? calendar(context, (value) => updateDate(context, value, currentState)) : null;
                                  }),
                                ),
                                itemsExceptions.contains(currentState['category'].toString().toLowerCase()) ? const SizedBox.shrink() : checkbox(context, currentState),
                              ],
                            ),
                            const SizedBox(height: 5),
      
                            checkFills(currentState) ? const SizedBox.shrink() : submit(context, currentState),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
