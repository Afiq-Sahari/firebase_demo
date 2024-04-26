import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier {
  String status = 'Light';
  bool isDarkMode = true;

  void toggleDarkMode(){
    isDarkMode = !isDarkMode;
    if(isDarkMode){
      status = 'Dark';
    }
    else{
      status = 'Light';
    }
    notifyListeners();
  }
}