import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/dark_mode.dart';
import 'package:flutter_application_1/core/themes/light_mode.dart';



/* ThemeProvider es una clase que nos ayuda a manejar el tema de nuestra aplicación. 
   Nos permite cambiar entre el modo oscuro y el modo claro de manera sencilla. */
   class ThemeProvider with ChangeNotifier {

    ThemeData _themeData = lightMode; // El tema por defecto es el modo claro

    ThemeData get themeData => _themeData; // Getter para obtener el tema actual

    bool get isDarkMode => _themeData == darkMode; // Verifica si el tema actual es el modo oscuro

    set themeData(ThemeData themeData) {
      _themeData = themeData; // Actualiza el tema
      notifyListeners(); // Notifica a los widgets que el tema ha cambiado
    }
    void toggleTheme() {
      if (isDarkMode) {
        themeData = lightMode; // Cambia al modo claro
      } else {
        themeData = darkMode; // Cambia al modo oscuro
      }
    }
  }