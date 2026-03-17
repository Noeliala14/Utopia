
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/data/services/auth_service.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //  Las herramientas (Controladores y Servicio)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instancia del servicio de autenticación

//  Limpieza de recursos 
  @override 
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
// La interfaz de usuario (UI)
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; 
    final isDark = Theme.of(context).brightness == Brightness.dark; // Verifica si el tema actual es oscuro para ajustar los colores de los íconos

    return Scaffold(
      // CAPA 1: 
      
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
        child: Center(
          child: SingleChildScrollView( // Para evitar problemas con el teclado
            padding: const EdgeInsets.all(30.0), // Margen 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente

              children: [
                //CAPA 2: EL LOGO DE UTOPÍA (En el centro y nítido)
                // UsO BoxFit.contain para que mantenga su calidad original
                Image.asset(
                  'assets/images/U without.png',
                  height: 150,
                  fit: BoxFit.contain, 

                 color: isDark ? colorScheme.primary.withOpacity(0.8) : null,
                colorBlendMode: isDark ? BlendMode.modulate : null,
              ),
                
                const SizedBox(height: 50), // Espacio entre logo y formulario

                // CAPA 3: EL FORMULARIO

                // Campo de Email
                TextField(
                  controller: _emailController, // Controlador para el email
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? colorScheme.secondary : Colors.white.withOpacity(0.8), // Ajusta el color de fondo según el tema
                    hintText: 'Introduce tu Email',
                    prefixIcon: Icon(Icons.email, color: colorScheme.primary), // Usa el color primario del tema para el ícono
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), // Bordes redondeados
                      borderSide: BorderSide.none, // Sin borde oscuro
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo de Contraseña
                TextField(
                  controller: _passwordController,// Controlador para la contraseña
                  obscureText: true, // Oculta contraseña
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? colorScheme.secondary : Colors.white.withOpacity(0.8), // Ajusta el color de fondo según el tema
                    hintText: 'Tu Contraseña',
                    hintStyle: TextStyle(color: colorScheme.inversePrimary.withOpacity(0.5)), // Ajusta el color del hint para que sea visible en modo oscuro
                    prefixIcon: Icon(Icons.lock, color: colorScheme.primary), // Usa el color primario del tema para el ícono
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Botón de Iniciar Sesión 
                ElevatedButton(
                  onPressed: () async{// Aquí la lógica de autenticación.
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      // try-catch para manejar errores de autenticación
                      try {
                        await _authService.signIn(email, password);
                        // Si el inicio de sesión es exitoso, el StreamBuilder en AuthGate detectará el cambio y redirigirá al HomeScreen automáticamente.
                      } catch (e) {
                        // Manejo de errores (puedes mostrar un mensaje de error al usuario)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al iniciar sesión: $e')),
                        );
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:colorScheme.primary,
                    foregroundColor:Colors.white,
                    minimumSize: const Size(double.infinity, 55), // Botón ancho y alto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5, // Sombra para que destaque
                  ),
                  child: const Text(
                    "INICIAR SESIÓN",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre botón y texto de registro

                // Texto para ir a Registro
                TextButton(
                  onPressed: () { 
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegisterScreen()) 
                    );
                  },
                  child: Text(
                    "¿No tienes cuenta? Regístrate aquí",
                  style: TextStyle(
                      color: isDark ? colorScheme.primary : Colors.blueGrey, // Color que combine con tu degradado
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                  ),
                 ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}