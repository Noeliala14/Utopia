import 'package:flutter/material.dart';
import 'classes/libros.dart';

 Libro miLibroPrueba = Libro(
    id: 1,
    titulo: 'Utopía',
    autor: 'Noelia',
    usuarioCreadorId: 101,
  );
 

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utopia',
      debugShowCheckedModeBanner: false, // Esto quita la etiqueta roja de "Debug"
      
      theme: ThemeData(),
      home: Scaffold(
        body: Center(
          child: Text(miLibroPrueba.titulo, style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
