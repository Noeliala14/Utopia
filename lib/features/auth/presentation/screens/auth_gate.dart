import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/home.screen.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/register_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Escucha los cambios en el estado de autenticación
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Muestra un indicador de carga mientras se verifica el estado de autenticación
          );
        } else if (snapshot.hasData) {
          return const HomeScreen(); // Si el usuario está autenticado, muestra la pantalla principal
        } else {
          return const RegisterScreen(); // Si no hay usuario autenticado, muestra la pantalla de registro/inicio de sesión
        }
      },
    );
  }
}