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
             
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon( 
                Icons.person_add, 
                size: 100, 
                color: colorScheme.primary.withValues (alpha: 0.8)), // Icono con un tono más suave del color primario

                const SizedBox(height: 30), // Espacio entre el ícono y los campos de texto
              

        
            // Campo de Correo Electrónico
            TextField(
              controller: _emailController, // Asocia el controlador al campo de texto
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

            TextField(
              controller: _passwordController, // Asocia el controlador al campo de texto
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

              const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async { // Acción al presionar el botón
                String email = _emailController.text.trim(); // Obtiene el correo electrónico ingresado
                String password = _passwordController.text.trim(); // Obtiene la contraseña ingresada

                try {
                  await _authService.signUp(email, password);
                   
                  if (!context.mounted) return; // Verifica si el contexto aún está montado antes de mostrar el SnackBar

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro exitoso')),
                  );
                  Navigator.pop(context); // Regresa a la pantalla anterior (login)
                } catch (e) {
                  if (!context.mounted) return; // Verifica si el contexto aún está montado antes de mostrar el SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al registrar: $e')),
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