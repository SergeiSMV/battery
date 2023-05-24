import 'package:flutter/material.dart';

Color firmColor = const Color(0xFF095D82);
// Color firmColor = Colors.black;
Color mainColor = const Color(0xFFff8c00);
Color secondColor = const Color(0xFFAFA7BB);
Color thirdColor = const Color.fromARGB(255, 241, 237, 227);
Color blueColor = const Color(0xFF1c1cf0);


// Status Color Gradienr
LinearGradient greenStatus = const LinearGradient(
  colors: [Colors.white, Colors.white, Color(0xFF39E639), Color(0xFF00CC00)], 
  begin: FractionalOffset(0.5, 0.0), 
  end: FractionalOffset(1.0, 0.0), 
  tileMode: TileMode.clamp);
LinearGradient blueStatus = const LinearGradient(
  colors: [Colors.white, Colors.white, Color(0xFFB2D2FF), Color(0xFF73AEFF)], 
  begin: FractionalOffset(0.5, 0.0), 
  end: FractionalOffset(1.0, 0.0), 
  tileMode: TileMode.clamp);
LinearGradient yellowStatus = const LinearGradient(
  colors: [Colors.white, Colors.white, Color(0xFFFFFF40), Color(0xFFFFFF00)], 
  begin: FractionalOffset(0.5, 0.0), 
  end: FractionalOffset(1.0, 0.0), 
  tileMode: TileMode.clamp);
LinearGradient redStatus = const LinearGradient(
  colors: [Colors.white, Colors.white, Color(0xFFFF4900), Color(0xFFFF0000)], 
  begin: FractionalOffset(0.5, 0.0), 
  end: FractionalOffset(1.0, 0.0), 
  tileMode: TileMode.clamp);


// Shadow Color
Color greenShadow = const Color(0xFF00CC00);
Color blueShadow = const Color(0xFF73AEFF);
Color yellowShadow = const Color(0xFFFFFF40);
Color redShadow = const Color(0xFFFF0000);