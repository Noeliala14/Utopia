import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key}); 
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
} 

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController(); // Controlador para el campo de correo electrónico
  final TextEditingController _passwordController = TextEditingController(); // Controlador para el campo de contraseña
  final TextEditingController _usernameController = TextEditingController(); // Controlador para el campo de nombre de usuario (opcional) 
  final TextEditingController _bioController = TextEditingController(); 
  final AuthService _authService = AuthService(); // Instancia del servicio de autenticación

  //  Limpieza de recursos 
  @override 
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Scaffold(

      extendBodyBehindAppBar: true, // Permite que el fondo se extienda detrás del AppBar
      appBar: AppBar(
        title: Text('Registro', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Hace el AppBar transparente
        elevation: 0, // Elimina la sombra del AppBar
        iconTheme: IconThemeData(color: colorScheme.primary), // Cambia el color de los íconos del AppBar
      ),

      body: Container(
      decoration: BoxDecoration(

        // Degradado de "sakura" para el fondo.
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
             ? [colorScheme.surface, colorScheme.surfaceContainerHighest] // Fondo sólido para modo oscuro
             : [colorScheme.primaryContainer.withValues(alpha: 0.3), colorScheme.surface],
          ),
      ),
             
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80), // Espacio superior para separar el contenido del AppBar
              Icon(Icons.person_add, size:100,
                color: colorScheme.primary.withValues(alpha: 0.8)),
              const SizedBox(height: 100), // Espacio entre el ícono y los campos de texto

            // Campo de Nombre de Usuario
              TextField(
                controller: _usernameController, // Asocia el controlador al campo de texto
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface.withValues(alpha: 0.7),
                  labelText: 'Nombre de usuario',
                  labelStyle: TextStyle(color: colorScheme.primary),
                  prefixIcon: Icon(Icons.person, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

            // Campo de Correo Electrónico
            TextField(
              controller: _emailController, 
              keyboardType: TextInputType.emailAddress, 
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
              filled: true,
                    fillColor: colorScheme.surface.withValues(alpha: 0.7),
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(color: colorScheme.primary),
                    prefixIcon: Icon(Icons.email, color: colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                ),
            ),
          
          

            const SizedBox(height: 16),

            // Campo de Contraseña
            TextField(
              controller: _passwordController, 
              obscureText: true,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surface.withValues(alpha: 0.7),
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: colorScheme.primary),
                prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // CAMPO BIO ← nuevo
              TextField(
                controller: _bioController,
                maxLines: 3, // ← permite varias líneas
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface.withValues(alpha: 0.7),
                  labelText: 'Cuéntanos algo sobre ti...',
                  labelStyle: TextStyle(color: colorScheme.primary),
                  prefixIcon: Icon(Icons.edit_note, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón de Registro
              ElevatedButton(
              onPressed: () async { // Acción al presionar el botón
                final email = _emailController.text.trim(); // Obtiene el correo electrónico ingresado
                final password = _passwordController.text.trim(); // Obtiene la contraseña ingresada
                


                try {
                  final username = _usernameController.text.trim();
                  final bio = _bioController.text.trim();


                  await _authService.signUp(email, password, username, bio);
                   
                  if (!context.mounted) return; // Verifica si el contexto aún está montado antes de mostrar el SnackBar

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro exitoso')),
                  );
                  Navigator.pop(context);

                } on FirebaseAuthException catch (e) {
                  if (!context.mounted) return;
                  
                  final mensaje = switch (e.code) {
                    'email-already-in-use' => 'El correo electrónico ya está en uso.',
                    'invalid-email' => 'El correo electrónico no es válido.',
                    'weak-password' => 'La contraseña es muy débil.',
                    'network-request-failed' => 'Error de red. Verifica tu conexión.',
                    _ => e.message ?? 'Error al registrar.',
                  };

                  // Regresa a la pantalla anterior (login)

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(mensaje)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary, // <--- ESTO PONE EL ROSA/GRANATE
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                  ),
              child: const Text('Registrarse', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ], // children
        ), //column
       ),
      ), //scaffold
      
    );
  } 
}