import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../static/models/bloc/accesses_bloc.dart';
import '../../static/ui/close_app_dialog.dart';
import 'sim_storage/bloc/logistic_router_bloc.dart';
import 'sort_department_elements.dart';

class Logistic extends StatelessWidget {
  final bool singleRoute;
  const Logistic({super.key, required this.singleRoute});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white.withOpacity(0.0), statusBarIconBrightness: Brightness.dark));
    return WillPopScope(
      onWillPop: singleRoute ? () => closeAppDialog(context) : null,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LogisticRouterBloc>(create: (context) => LogisticRouterBloc()),
        ],
        child: Builder(
          builder: (context) {
            List accesses = context.watch<AccessesBloc>().state;
            List elements = sortDepartmentElements(accesses, 'logistic');
            return Scaffold(
              body: BlocBuilder<LogisticRouterBloc, int>(
                builder: ((context, state) {
                  return elements[state]['route'];
                })
              ),
            );
          }
        ),
      ),
    );
  }
}
