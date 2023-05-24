

import 'package:flutter/material.dart';

Future<bool> closeAppDialog(BuildContext context) async {
  return await showDialog( 
    context: context,
    builder: (context) => AlertDialog(
      content: const Text('Вы действительно хотите закрыть приложение?'),
      actions:[

        TextButton(
          onPressed: () => Navigator.of(context).pop(true), 
          child: const Text('закрыть'),
        ),

        TextButton(
          onPressed: () => Navigator.of(context).pop(false), 
          child: const Text('остаться'),
        ),

      ],
    ),
  ) ?? false;
}