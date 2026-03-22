import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/data/services/auth_service.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key}); 
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
} 

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController(); // Controlador para el campo de correo electrónico
  final TextEditingController _passwordController = TextEditingController(); // Controlador para el campo de contraseña
  final AuthService _authService = AuthService(); // Instancia del servicio de autenticación

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Scaffold(

      body: Container(
      decoration: BoxDecoration(
          gradient: isDark 
            ? null 
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8FD3F4), Color(0xFFD4FC79)],
              ),
       color: isDark ? colorScheme.surface : null, 
      ), 

        child: Scaffold(
          backgroundColor: Colors.transparent, // Para que se vea el fondo de atrás
          appBar: AppBar(
            title: Text('Registro', style: TextStyle(color: colorScheme.inversePrimary)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: colorScheme.inversePrimary),
          ),

      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de Correo Electrónico
            TextField(
              controller: _emailController, // Asocia el controlador al campo de texto
              obscureText: true,
              style: TextStyle(color: colorScheme.inversePrimary),
              decoration: InputDecoration(
              filled: true,
                    fillColor: isDark ? colorScheme.secondary : Colors.white.withValues(alpha: 0.8),
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(color: colorScheme.inversePrimary.withValues(alpha: 0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                ),
            ),
          
          

            const SizedBox(height: 16),

            TextField(
              controller: _passwordController, // Asocia el controlador al campo de texto
              obscureText: true,
              style: TextStyle(color: colorScheme.inversePrimary),
              decoration: InputDecoration(
                filled: true,
                    fillColor: isDark ? colorScheme.secondary : Colors.white.withValues(alpha: 0.8),
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: colorScheme.inversePrimary.withValues(alpha: 0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async { // Acción al presionar el botón
                String email = _emailController.text.trim(); // Obtiene el correo electrónico ingresado
                String password = _passwordController.text.trim(); // Obtiene la contraseña ingresada

                final user = await _authService.signUp(email, password); // Llama al método de registro del servicio de autenticación

                if (context.mounted) { // Verifica si el contexto aún está montado antes de mostrar el SnackBar


                if (user != null) { // Verifica si el usuario se registró correctamente
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro exitoso')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error en el registro')),
                  );
                }
              }
              },
              style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary, // <--- ESTO PONE EL ROSA/GRANATE
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
              child: const Text('Registrarse', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ], // children
        ), //column
       ),
      ), //scaffold
      ),
    );
  } 
}