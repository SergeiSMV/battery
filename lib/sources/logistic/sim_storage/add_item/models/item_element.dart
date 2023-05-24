import 'package:flutter/material.dart';

import '../../../../../../static/ui/colors.dart';

itemElement(String leading, String blocText, String blocEmpty, Function func,){
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: GestureDetector(
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(leading, style: const TextStyle(color: Colors.black, fontSize: 12)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(blocText.isEmpty ? blocEmpty : blocText, style: TextStyle(fontSize: 13, color: blocText.isEmpty ? Colors.grey : firmColor),)
            ),
          ],
        ),
      ),
      onTap: (){ func(); },
    ),
  );
}