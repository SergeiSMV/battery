

import 'package:flutter/material.dart';

class ItemImagesFullScreen extends StatelessWidget {
  final String imageUrl;
  const ItemImagesFullScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        panEnabled: true,
        minScale: 1.0,
        maxScale: 4.0,
        constrained: true,
        child: Center(
          child: GestureDetector(
            child: Image.network(imageUrl, fit: BoxFit.fill),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        )
      ),
    );
  }
}