import 'package:battery/static/models/bloc/accesses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../static/ui/close_app_dialog.dart';
import '../../../static/ui/colors.dart';
import '../models/sort_departments.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white.withOpacity(0.0), statusBarIconBrightness: Brightness.dark));
    return WillPopScope(
      onWillPop: () => closeAppDialog(context),
      child: BlocProvider.value(
        value: BlocProvider.of<AccessesBloc>(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<AccessesBloc, List>(
            builder: ((context, state) {
              return state == ['load'] ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: firmColor,)) 
              : SortDeaprtments(accesses: state, context: context).sortDepartments();
            })
          ),
        ),
      ),
    );
  }  
}