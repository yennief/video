import 'package:flutter/foundation.dart';

class CompassManager extends ChangeNotifier {
  int ang = 0;

  int get getAng => ang;

  void setAng(int newAng) {
    ang = newAng;
    notifyListeners();
  }
}
