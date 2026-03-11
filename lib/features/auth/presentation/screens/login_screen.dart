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
    return Scaffold(
      // CAPA 1: EL FONDO CON DEGRADADO 
      
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8FD3F4), // Azul clarito
              Color(0xFFD4FC79), // Verde lima
            ],
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

                  isAntiAlias: true, 
                  filterQuality: FilterQuality.high, // Mejora la calidad de la imagen
                ),
                
                const SizedBox(height: 50), // Espacio entre logo y formulario

                // CAPA 3: EL FORMULARIO
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8), // Fondo semi-transparente
                    hintText: 'Introduce tu Email',
                    prefixIcon: const Icon(Icons.email, color: Colors.blueGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none, // Sin borde oscuro
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true, // Oculta contraseña
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    hintText: 'Tu Contraseña',
                    prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 192, 134, 192)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Botón de Entrar 
                ElevatedButton(
                  onPressed: () {
                    // Aquí iría la lógica de autenticación, por ahora solo es un botón sin funcionalidad
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 192, 134, 192),
                    foregroundColor: Colors.white,
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
                  child: const Text(
                    "¿No tienes cuenta? Regístrate aquí",
                  style: TextStyle(
                      color: Colors.blueGrey, // Color que combine con tu degradado
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