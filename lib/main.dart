import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/home.screen.dart';
import 'package:flutter_application_1/core/themes/theme_provider.dart';
import 'package:provider/provider.dart';


// 1. EL ARRANQUE (Siempre arriba)
void main() async{ //Asíncrono porque necesitamos esperar a que Firebase se inicialice antes de ejecutar la aplicación
  WidgetsFlutterBinding.ensureInitialized(); //Aseguramos de que Flutter esté listo
=======
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/auth_gate.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/core/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/core/supabase_conf.dart/configuracion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



// 1. EL ARRANQUE 
void main() async{ //Asíncrono porque necesitamos esperar a que Firebase se inicialice antes de ejecutar la aplicación
  WidgetsFlutterBinding.ensureInitialized();

   //Aseguramos que Flutter esta listo para ejecutar código asíncrono antes de inicializar Firebase. Esto es necesario para evitar errores relacionados con la inicialización de Firebase antes de que Flutter esté completamente configurado.
>>>>>>> feat-theme-sakura
  await Firebase.initializeApp(              // Inicializamos Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );

<<<<<<< HEAD
=======
  // Inicializamos Supabase con la URL y la clave anónima de nuestro proyecto. Esto es necesario para poder usar los servicios de Supabase en nuestra aplicación, como autenticación, base de datos, etc.
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );



>>>>>>> feat-theme-sakura
  runApp(
    ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MainApp(),
<<<<<<< HEAD
  )); // Aquí ese inicia la aplicación. runApp()uso de ChangeNotifierProvider para proporcionar el ThemeProvider a toda la aplicación, lo que nos permitirá cambiar el tema de manera dinámica.
}
=======
  )); // Aquí se inicia la aplicación. runApp()uso de ChangeNotifierProvider para proporcionar el ThemeProvider a toda la aplicación, lo que nos permitirá cambiar el tema de manera dinámica.
}


>>>>>>> feat-theme-sakura
// 2. LA CONFIGURACIÓN (El cerebro)
class MainApp extends StatelessWidget {
  const MainApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utopia',
      debugShowCheckedModeBanner: false, // Esto quita la etiqueta roja de "Debug"
      
<<<<<<< HEAD
      home: const HomeScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
=======
      home: const AuthGate(), // La pantalla de autenticación que decide qué mostrar según el estado del usuario
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
  }

>>>>>>> feat-theme-sakura

// 3. LA PANTALLA (Lo que se ve)

// 4. LOS COMPONENTES (Los ladrillos)
//