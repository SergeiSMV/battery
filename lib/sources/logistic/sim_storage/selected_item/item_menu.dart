import 'package:flutter/material.dart';

import 'item_buttons.dart';
import 'models/item_accesses.dart';


Widget itemPanel(BuildContext selectedItemContext, ItemButtonAccess buttonsAccesses, ItemButtons button){
  return SizedBox(
    height: 60,
    width: MediaQuery.of(selectedItemContext).size.width,
    child: Center(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            buttonHeight: 52.0,
            buttonMinWidth: 90.0,
            children: [
              buttonsAccesses.replaceAccess(button.replaceButton()),
              buttonsAccesses.sendQrAccess(button.sendQrButton()),
              buttonsAccesses.historyAccess(button.historyButton()),
              buttonsAccesses.photoAccess(button.photoAddButtons()),
              buttonsAccesses.statusAccess(button.statusButton()),
              buttonsAccesses.editAccess(button.editButton()),
              buttonsAccesses.deleteAccess(button.deleteButton()),
            ]
          )
        ],
      ),
    ),
  );
}