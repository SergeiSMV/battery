

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../../../static/ui/colors.dart';
import 'add_nomenclature/add_nomenclature.dart';
import 'allnomenclature.dart';
import 'bloc/nomenclature_bloc.dart';
import 'nomenclature_appbar.dart';

class Nomenclature extends StatelessWidget {
  final List nomenclature;
  const Nomenclature({super.key, required this.nomenclature});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc(),),
        BlocProvider<NomenclatureBloc>(create: (context) => NomenclatureBloc()..add(NomenclatureChange(data: nomenclature))),
      ], 
      child: Builder(
        builder: (context){
          return Scaffold(
            appBar: const NomenclatureAppBar().appBar(),
            floatingActionButton: FloatingActionButton(
              elevation: 2.0,
              onPressed: (){ AddNomenclarure(currentState: nomenclature, nomenclatureContext: context).addNomenclarure(); }, 
              backgroundColor: mainColor, 
              child: const Icon(Icons.add, color: Colors.white,)
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: BlocBuilder<NomenclatureBloc, List>(
                    builder: ((context, state){
                      return AllNomenclature(parrentContext: context, currentState: state).controller();
                    })
                  )
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}