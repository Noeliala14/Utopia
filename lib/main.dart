import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home.screen.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';


// 1. EL ARRANQUE (Siempre arriba)
void main() {
  runApp(
    ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MainApp(),
  )); // Aquí ese inicia la aplicación. runApp()uso de ChangeNotifierProvider para proporcionar el ThemeProvider a toda la aplicación, lo que nos permitirá cambiar el tema de manera dinámica.
}
// 2. LA CONFIGURACIÓN (El cerebro)
class MainApp extends StatelessWidget {
  const MainApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utopia',
      debugShowCheckedModeBanner: false, // Esto quita la etiqueta roja de "Debug"
      
      home: const HomeScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

// 3. LA PANTALLA (Lo que se ve)

// 4. LOS COMPONENTES (Los ladrillos)
//