import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User; // Evitar conflicto de nombres con FirebaseAuth User

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para registrar un nuevo usuario
  Future<User?> signUp(String email, String password, String username, String bio) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Supabase.instance.client.from('profiles').insert({
        'id': userCredential.user!.uid,
        'email': email,
        'user_name': username,// Ejemplo de nombre de usuario
        'bio': bio, 
      });


      return userCredential.user;
    } on FirebaseAuthException {
      rethrow; // rethrow la excepción para que pueda ser manejada en la UI
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
    } on FirebaseAuthException {
      rethrow; // rethrow para que el error pueda ser manejado en la UI
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Método para obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
