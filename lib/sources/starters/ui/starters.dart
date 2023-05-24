import 'package:flutter/material.dart';

import '../../../static/ui/close_app_dialog.dart';

class Starters extends StatelessWidget {
  final bool singleRoute;
  const Starters({super.key, required this.singleRoute});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: singleRoute ? () => closeAppDialog(context) : null,
      child: const Scaffold(
        body: Center(child: Text('департамент производства стартерных АКБ'),),
      ),
    );
  }
}