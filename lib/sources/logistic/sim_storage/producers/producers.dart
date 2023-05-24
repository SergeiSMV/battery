

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../static/models/bloc/is_tapped_bloc.dart';
import '../../../../../static/ui/colors.dart';
import 'addproducers.dart';
import 'allproducers.dart';
import 'bloc/producers_bloc.dart';
import 'producers_appbar.dart';

class Producers extends StatelessWidget {
  final List producers;
  const Producers({super.key, required this.producers});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IsTappedBloc>(create: (context) => IsTappedBloc(),),
        BlocProvider<ProducersBloc>(create: (context) => ProducersBloc()..add(ProducersChange(data: producers))),
      ], 
      child: Builder(
        builder: (context){
          return Scaffold(
            appBar: const ProducersAppBar().appBar(),
            floatingActionButton: FloatingActionButton(
              elevation: 2.0,
              onPressed: (){ 
                AddProducers(currentState: producers, producersContext: context).addProducers(); 
              }, 
              backgroundColor: mainColor, 
              child: const Icon(Icons.add, color: Colors.white,)
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: BlocBuilder<ProducersBloc, List>(
                    builder: ((context, state){
                      return AllProducers(parrentContext: context, currentState: state).controller();
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