import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../static/ui/colors.dart';
import '../../../../accounts/models/checkbox_color.dart';
import '../bloc/additem_bloc.dart';

checkbox(BuildContext context, Map currentState) {
  bool value = currentState['pallet_size'] == 'standart' ? false : true;
  return Padding(
    padding: const EdgeInsets.only(right: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(checkBoxColor),
            value: value,
            onChanged: (bool? value) {
              value! ? currentState['pallet_size'] = 'big' : currentState['pallet_size'] = 'standart';
              context.read<AddItemBloc>().add(AddItemChange(data: Map.from(currentState)));
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text('на большом паллете', style: TextStyle(fontSize: 12, fontFamily: 'Montserrat', color: firmColor)),
        )
      ],
    ),
  );
}