import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/profile_screen.dart';
import 'package:flutter_application_1/features/auth/data/services/auth_service.dart';

class DrawersOne extends StatelessWidget {
  const DrawersOne({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [colorScheme.surface, colorScheme.surfaceContainerHighest]
                : [colorScheme.primaryContainer.withValues(alpha: 0.3), colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/profile_placeholder.png'),
                child: Icon(Icons.person, size: 50, color: colorScheme.primary),
              ),
              const SizedBox(height: 20),
              Text(
                "U T O P Í A",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: colorScheme.primary.withValues(alpha: 0.2),
                indent: 24,
                endIndent: 25,
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.home, color: colorScheme.primary),
                title: Text(
                  "I N I C I O",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: colorScheme.primary),
                title: Text(
                  "M I  P E R F I L",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              const Spacer(),
              ListTile(
                leading: Icon(Icons.logout, color: colorScheme.primary),
                title: Text(
                  "C E R R A R  S E S I Ó N",
                  style: TextStyle(
                    color: colorScheme.primary,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  final authService = AuthService();
                  Navigator.pop(context);
                  await authService.signOut();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
