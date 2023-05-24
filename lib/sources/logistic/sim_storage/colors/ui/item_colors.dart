

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../../../static/ui/colors.dart';
import '../bloc/colors_bloc.dart';
import 'addcolors.dart';
import 'allcolors.dart';
import 'colors_appbar.dart';

class ItemColors extends StatelessWidget {
  final List colors;
  const ItemColors({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc(),),
        BlocProvider<ColorsBloc>(create: (context) => ColorsBloc()..add(ColorsChange(data: colors))),
      ], 
      child: Builder(
        builder: (context){
          return Scaffold(
            appBar: const ColorsAppBar().appBar(),
            floatingActionButton: FloatingActionButton(
              elevation: 2.0,
              onPressed: (){ AddColors(currentState: colors, colorsContext: context).addColors(); }, 
              backgroundColor: mainColor, 
              child: const Icon(Icons.add, color: Colors.white,)
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: BlocBuilder<ColorsBloc, List>(
                    builder: ((context, state){
                      return AllColors(parrentContext: context, currentState: state).controller();
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