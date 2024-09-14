import 'package:flutter/cupertino.dart';

class Background {
  static BoxDecoration getBackground() {
    return BoxDecoration(
        image: DecorationImage(
      image: AssetImage('assets/starman_bg.png'),
      fit: BoxFit.cover,
    ));
  }
}
