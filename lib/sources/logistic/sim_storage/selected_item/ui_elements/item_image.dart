import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../item_buttons.dart';
import '../models/item_accesses.dart';
import 'item_imagefull.dart';



Widget itemImages(List imageLinks, ItemButtons buttons, ItemButtonAccess buttonsAccesses){
  return CarouselSlider.builder(
    itemCount: imageLinks.length, 
    options: CarouselOptions(
      reverse: true,
      enableInfiniteScroll: imageLinks.length == 1 ? false : true,
      autoPlay: false,
      enlargeCenterPage: true,
    ),
    itemBuilder: (BuildContext context, int index, int pageViewIndex){
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Stack(
          children: [
            
            GestureDetector(
              child: SizedBox(height: 300, width: 1000, child: Image.network(imageLinks[index], fit: BoxFit.cover, width: 1000.0)),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemImagesFullScreen(imageUrl: imageLinks[index].toString(),)));
              },
            ),
            
            Positioned(
              right: 10,
              top: 20,
              child: buttonsAccesses.delPhotoAccess(buttons.photoDelButtons(imageLinks, index))
            )

          ],
        ));
      },
  );
}