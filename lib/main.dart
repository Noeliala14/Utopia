import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/auth_gate.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/core/themes/theme_provider.dart';
import 'package:provider/provider.dart';


// 1. EL ARRANQUE (Siempre arriba)
void main() async{ //Asíncrono porque necesitamos esperar a que Firebase se inicialice antes de ejecutar la aplicación
  WidgetsFlutterBinding.ensureInitialized(); //Aseguramos de que Flutter esté listo
  await Firebase.initializeApp(              // Inicializamos Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

// 3. LA PANTALLA (Lo que se ve)

// 4. LOS COMPONENTES (Los ladrillos)
//