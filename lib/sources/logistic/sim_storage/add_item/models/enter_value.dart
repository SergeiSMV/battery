import 'package:flutter/material.dart';

import '../../../../../../static/ui/colors.dart';

enterValue(String leading, String hint, TextInputType type, TextEditingController controller, change){
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8),
    child: Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(leading, style: const TextStyle(color: Colors.black, fontSize: 12)),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: controller,
                readOnly: false,
                keyboardType: type,
                style: TextStyle(fontSize: 13, color: firmColor),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontFamily: 'Montserrat'),
                  hintText: hint,
                ),
                onChanged: (value){ change(value); },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}