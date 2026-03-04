import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userStateChanges => _auth.authStateChanges(); // Stream para escuchar cambios en el estado de autenticación

  // Método para registrar un nuevo usuario
  Future<User?> signUp(String email, String password) async { 
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error en el registro: $e');
      return null;
    }
  }

  // Método para iniciar sesión
  Future<User?> signIn(String email, String password) async { 
    try { 
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) { // Manejo de errores, como credenciales incorrectas o problemas de red
      print('Error en el inicio de sesión: $e'); 
      return null;
    } // El método devuelve el usuario autenticado o null si hubo un error
  }

  // Método para cerrar sesión
  Future<void> signOut() async { 
    await _auth.signOut(); 
  }

  // Método para obtener el usuario actual
  User? getCurrentUser() { // Devuelve el usuario actualmente autenticado, o null si no hay ninguno
    return _auth.currentUser; // Esto es útil para verificar si el usuario ya está autenticado al iniciar la aplicación
  } 
} 
