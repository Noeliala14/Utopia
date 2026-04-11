import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  final _user = FirebaseAuth.instance.currentUser;

  Map<String, dynamic>? _profile;
  bool _isLoading = true;

    // ✅ Añade estas dos líneas aquí
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
}

  Future<void> _loadProfile() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', _user?.uid ?? '')
          .single();

      setState(() {
        _profile = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

    // Método para abrir el diálogo de edición
  Future<void> _editProfile() async {
    final colorScheme = Theme.of(context).colorScheme;

    // Rellena los campos con los datos actuales
    _usernameController.text = _profile?['user_name'] ?? '';
    _bioController.text = _profile?['bio'] ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar perfil',
            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                labelStyle: TextStyle(color: colorScheme.primary),
                prefixIcon: Icon(Icons.person, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(color: colorScheme.primary),
                prefixIcon: Icon(Icons.edit_note, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Botón cancelar
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ),
          // Botón guardar
          ElevatedButton(
            onPressed: () async {
              await _saveProfile();
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // Método para guardar en Supabase
  Future<void> _saveProfile() async {
    try {
      await _supabase.from('profiles').update({
        'user_name': _usernameController.text.trim(),
        'bio':       _bioController.text.trim(),
      }).eq('id', _user?.uid ?? '');

      // Refresca el perfil en pantalla
      await _loadProfile();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Perfil actualizado! ✅')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el perfil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Datos reales de Firebase + Supabase
    final String email = _user?.email ?? 'Sin email';
    final String username = _profile?['user_name'] ?? email.split('@')[0];
    final String bio = _profile?['bio'] ?? 'Amante de los libros 📚';
    final int booksExchanged = _profile?['books_exchanged'] ?? 0;
    final bool isEcoHero = _profile?['is_eco_hero'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.primary,

        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editProfile,
            tooltip: 'Editar perfil',
          ),
        ],
      ),
      
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [colorScheme.surface, colorScheme.surfaceContainerHighest]
                : [
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                    colorScheme.surface
                  ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // AVATAR
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          username.isNotEmpty
                              ? username[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // NOMBRE
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // EMAIL
                      Text(
                        email,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // BIO
                      Text(
                        bio,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // BADGE ECO HÉROE
                      if (isEcoHero)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.eco,
                                  color: colorScheme.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '🌱 Eco Héroe',
                                style: TextStyle(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // ESTADÍSTICA — libros intercambiados
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.swap_horiz,
                                  color: colorScheme.primary, size: 32),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$booksExchanged',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    'libros intercambiados',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
