import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/profile_screen.dart';
import 'package:flutter_application_1/features/auth/data/services/auth_service.dart';


/*DrawersOne es un widget que representa una pantalla con un Drawer (menú lateral) */
class DrawersOne extends StatelessWidget {
  const DrawersOne({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Drawer
    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50), 
           
              Icon(
                Icons.person,
                size: 70,
                color: colorScheme.primary,
            ),

            const SizedBox(height: 20),
            Divider(color: colorScheme.primary.withOpacity(0.2), indent: 25, endIndent: 25),
            const SizedBox(height: 10),

            ListTile(
              leading: Icon(Icons.home, color: colorScheme.primary),
              title: Text(
                "I N I C I O",
                 style: TextStyle(color: colorScheme.inversePrimary, letterSpacing: 2)),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: Icon(Icons.person_outline, color: colorScheme.primary),
              title: Text("P E R F I L", style: TextStyle(color: colorScheme.inversePrimary, letterSpacing: 2)),
              onTap: () {
                Navigator.pop(context);
                // Navegamos a la pantalla de perfil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
              },
            ),

            const Spacer(),

            // 4. Opción: Cerrar Sesión
            ListTile(
              leading: Icon(Icons.logout, color: colorScheme.primary),
              title: Text("C E R R A R  S E S I Ó N", style: TextStyle(color: colorScheme.inversePrimary, letterSpacing: 2)),
              onTap: () async {
                // Instanciamos el servicio
                final authService = AuthService();

                // Cerramos sesión
                Navigator.pop(context);

                // Ejecutamos la lógica de cierre de sesión
                await authService.signOut();
              },
            ),
            const SizedBox(height: 20),
         ],
        ),
   
       ),
     
    );
  }
}
