
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

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:isDark
            ? [colorScheme.surface, colorScheme.surfaceContainerHighest] 
              : [colorScheme.primaryContainer.withValues(alpha: 0.3), colorScheme.surface],
          ),
        
       
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
                // filtro para modo oscuro 
                color: isDark ? colorScheme.primary.withValues(alpha: 0.8) : null,
                colorBlendMode: isDark ? BlendMode.modulate : null,
              ),
                
                const SizedBox(height: 50), // Espacio entre logo y formulario

                // CAPA 3: 
                //EL FORMULARIO

                // Campo de Email
                TextField(
                  controller: _emailController, // Controlador para el email
                  style: TextStyle(color: colorScheme.onSurface), // Ajusta el color del texto según el tema
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surface.withValues(alpha: 0.7),
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
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surface.withValues(alpha: 0.7),
                    hintText: 'Tu Contraseña',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
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
                  onPressed: () async{
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      // try-catch para manejar errores de autenticación
                      try {
                        await _authService.signIn(email, password); // Llama al método de inicio de sesión del servicio de autenticación

                      } catch (e) {
                        // escudo 
                        if (!context.mounted) return; // Verifica si el contexto aún está montado antes de mostrar el SnackBar

                        // Manejo de errores (puedes mostrar un mensaje de error al usuario)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al iniciar sesión: $e')),
                        );
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:colorScheme.primary,
                    foregroundColor:colorScheme.onPrimary,
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