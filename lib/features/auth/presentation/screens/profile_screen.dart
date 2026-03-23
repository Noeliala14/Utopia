import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.primary,
      ),
      extendBodyBehindAppBar: true, // Permite que el fondo se extienda detrás del AppBar
      body: Container(
         width: double.infinity,
         height: double.infinity,
         decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
            ? [colorScheme.surface, colorScheme.surfaceContainerHighest]
            : [colorScheme.primaryContainer.withValues(alpha: 0.3), colorScheme.surface],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Avatar de perfil
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                child: Icon(Icons.person, size: 60, color: colorScheme.primary),
              ),
            const SizedBox(height: 20),

            Text(
              "Nombre de Usuario",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface
              ),
            ),
              
            const SizedBox(height: 10),

            Text(
              "Amante de los libros",
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 30), 
                
              
            
            ],
          ),
        ),
      ),
    );
  }
}
