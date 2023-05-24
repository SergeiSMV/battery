import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'colors.dart';

systemMessage(BuildContext context, String text, [String path = '']){
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            path.isEmpty ? const SizedBox.shrink() : SizedBox(height: 70, width: 70,child: Lottie.asset(path)),
            const SizedBox(height: 10),
            Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: firmColor, fontSize: 12, fontFamily: 'Montserrat')))),
              ],
            )),
          ],
        ),
      );
    });
  }