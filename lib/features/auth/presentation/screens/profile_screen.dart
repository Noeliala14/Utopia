import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
       title: Text(
          "Mi Perfil", 
          style: TextStyle(color: colorScheme.inversePrimary)
        ),
        backgroundColor: colorScheme.primary, // Usamos el color primario del tema para el AppBar
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4), // Borde exterior
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary, // Borde granate o rosa
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.secondary, // Fondo verde pastel o gris
                child: Icon(
                  Icons.person, 
                  size: 60, 
                  color: colorScheme.primary // Icono granate o rosa
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "@UtopiaUser", 
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: colorScheme.inversePrimary // Color que contraste con el fondo
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Amante de los libros",
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.inversePrimary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
