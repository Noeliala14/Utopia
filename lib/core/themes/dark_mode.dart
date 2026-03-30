<<<<<<< HEAD
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 20, 20, 20),
    primary: const Color.fromARGB(255, 105, 105, 105),
    secondary: const Color.fromARGB(255, 30, 30, 30),
    tertiary: const Color.fromARGB(255, 47, 47, 47),
    inversePrimary: Colors.grey.shade300,
=======
import 'package:flex_color_scheme/flex_color_scheme.dart'; //Importamos la libreria y en pubspec.yaml agregamos flex_color_scheme: 
import 'package:flutter/material.dart';

// tanto light como dark mode comparten el mismo esquema de colores y configuraciones,
// solo cambia el modo de superficie para adaptarse a cada tema

ThemeData darkMode = FlexThemeData.dark(
  // Usamos el esquema de colores seleccionado de FlexColorScheme en este caso "sakura"
  scheme: FlexScheme.sakura,

  // Definimos el modo de superficie para que los colores de fondo sean más oscuros y contrasten con los elementos claros
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  
  useMaterial3: true,// Habilitamos Material 3 para obtener un diseño más moderno y adaptativo

  subThemesData: const FlexSubThemesData(
    defaultRadius: 15.0, // definimos radio de bordes para botones, tarjetas, etc.
    useMaterial3Typography: true, // tipografia de google fonts adaptativa a Material 3
>>>>>>> feat-theme-sakura
  ),
);
