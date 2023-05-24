import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:collection/collection.dart';


import '../../../../../static/ui/colors.dart';
import 'edit_nomenclature/edit_nomenclature.dart';

class AllNomenclature{
  final List currentState;
  final BuildContext parrentContext;
  const AllNomenclature({required this.currentState, required this.parrentContext});

  controller(){
    Function eq = const ListEquality().equals;
    List<dynamic> compare = ['load'];
    bool result = eq(currentState, compare);
    
    return result ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,)) : 
      currentState.isEmpty ? _emptyStorage() : _allItemsViewer();
  }

  _allItemsViewer(){
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: currentState.length,
      itemBuilder: (context, index){
        
        currentState.sort((a, b) {return a['category'].toString().compareTo(b['category'].toString());});
        String category = currentState[index]['category'];
        String name = currentState[index]['name'];
        String producer = currentState[index]['producer'];
        String unit = currentState[index]['unit'];

        // print(currentState);

    
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle, 
              borderRadius: BorderRadius.circular(5),
              boxShadow:  [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0.2, blurRadius: 0.2, offset: const Offset(0, 2))]
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                tileColor: Colors.white,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('категория: $category', style: TextStyle(fontSize: 12, color: firmColor), textAlign: TextAlign.center,),
                    Text('наименование: $name', style: TextStyle(fontSize: 12, color: firmColor), textAlign: TextAlign.center,),
                    Text('поставщик: $producer', style: TextStyle(fontSize: 12, color: firmColor), textAlign: TextAlign.center,),
                    Text('ед. измерения: $unit', style: TextStyle(fontSize: 12, color: firmColor), textAlign: TextAlign.center,),
                  ],
                ),
                onTap: (){
                  EditNomenclarure(nomenclatureContext: parrentContext, currentState: currentState, index: index).editNomenclarure();
                },
              ),
            )
          ),
        );
      }
    );
  }

  _emptyStorage(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200, width: 200,child: Lottie.asset('lib/images/lottie/not_found.json'),),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('номенклатуры не найдено', textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 12, fontFamily: 'Montserrat')),
            ),
          ],
        ),
      ),
    );
  }

}