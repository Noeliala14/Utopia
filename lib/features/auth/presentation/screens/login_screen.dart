import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                // Usamos BoxFit.contain para que mantenga su calidad original
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
                    // Mañana lo conectamos con Firebase en esta rama feat-login
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}