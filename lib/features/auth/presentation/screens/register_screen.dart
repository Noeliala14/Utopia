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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController, // Asocia el controlador al campo de texto
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController, // Asocia el controlador al campo de texto
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true, // Oculta el texto para la contraseña
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async { // Acción al presionar el botón
                String email = _emailController.text.trim(); // Obtiene el correo electrónico ingresado
                String password = _passwordController.text.trim(); // Obtiene la contraseña ingresada
                final user = await _authService.signUp(email, password); // Llama al método de registro del servicio de autenticación

                if (user != null) { // Verifica si el usuario se registró correctamente
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro exitoso')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error en el registro')),
                  );
                }
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}