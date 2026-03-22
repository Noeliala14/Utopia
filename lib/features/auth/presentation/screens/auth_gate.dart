import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/home.screen.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/login_screen.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

// Sincroniza el usuario autenticado de Firebase con Supabase
  Future<void> _syncUserWithSupabase(fb_auth.User firebaseUser) async {
    final supabase = Supabase.instance.client;
    
    // Intentamos insertar el perfil. Si ya existe, Supabase no hará nada (gracias al ID único)
    await supabase.from('profiles').upsert({
      'id': firebaseUser.uid, // Usamos el mismo ID de Firebase
      'email': firebaseUser.email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb_auth.User?>(
      stream: fb_auth.FirebaseAuth.instance.authStateChanges(), // Escucha los cambios en el estado de autenticación
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Muestra un indicador de carga mientras se verifica el estado de autenticación
          );
        } else if (snapshot.hasData) {
          // Si hay un usuario autenticado, sincronizamos con Supabase
          _syncUserWithSupabase(snapshot.data!);
          return const HomeScreen(); // Si el usuario está autenticado, muestra la pantalla principal
        } else {
          return const LoginScreen(); // Si no hay usuario autenticado, muestra la pantalla de registro/inicio de sesión
        }
      },
    );
  }
}