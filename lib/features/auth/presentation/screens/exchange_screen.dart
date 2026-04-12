import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/public_profile_screen.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  List<Map<String, dynamic>> _availableBooks = [];
  bool _isLoading = true;

  // Widget para mostrar un placeholder cuando no hay imagen de portada disponible
  Widget _buildBookPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 50,
      height: 70,
      color: colorScheme.primaryContainer,
      child: Icon(Icons.book, color: colorScheme.primary),
    );
  }

  // Método para el diálogo de solicitud de intercambio 
  Future<void> _showRequestDialog(
    BuildContext context,
    Map<String, dynamic> book,
    String ownerName,
    ColorScheme colorScheme,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Solicitar intercambio', 
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book['title'] ?? 'Sin título',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              'Ofrecido por: $ownerName',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 16),

            Text(
              'Se enviará una solicitud al propietario. Podréis coordinar el intercambio una vez aceptada.',
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
           ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('¡Solicitud enviada a $ownerName! 📚'),
                  backgroundColor: colorScheme.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Solicitar'),
          ),
        ],
      ),
    );
  }
            

  @override
  void initState() {
    super.initState();
    _loadAvailableBooks();
  }

  Future<void> _loadAvailableBooks() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    final response = await Supabase.instance.client
        .from('books_circulation')
        .select('''*,propietario:original_owner_id (user_name)''')
        .eq('status', 'disponible')
        .neq('original_owner_id', currentUid ?? '');

    // Convertimos la respuesta a una lista de mapas y actualizamos el estado
    setState(() {
      _availableBooks = List<Map<String, dynamic>>.from(response);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Diseño de la pantalla de libros disponibles
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Libros disponibles',
          style: TextStyle(
            color: colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        elevation: 4,
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
      ),
      body: Container(
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
            : _availableBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_outlined,
                            size: 80,
                            color: colorScheme.primary.withValues(alpha:  0.4)),
                        const SizedBox(height: 16),
                        Text(
                          'No hay libros disponibles aún.',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sé el primero en ofrecer un libro.',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _availableBooks.length,
                    itemBuilder: (context, index) {
                      final book = _availableBooks[index];
                      final isbn = book['isbn'] as String?;
                      final coverUrl = isbn != null
                          ? 'https://covers.openlibrary.org/b/isbn/$isbn-M.jpg'
                          : null;
                      final ownerName =
                          book['propietario']?['user_name'] ?? 'Usuario';
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: coverUrl != null
                                ? Image.network(
                                    coverUrl,
                                    width: 50,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _buildBookPlaceholder(colorScheme),
                                  )
                                : _buildBookPlaceholder(colorScheme),
                          ),
                          
                          title: Text(
                            book['title'] ?? 'Sin título',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          subtitle: GestureDetector(
                            onTap: () {
                              final ownerId = book['original_owner_id'] as String;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PublicProfileScreen(
                                    userId: ownerId,
                                    userName: ownerName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                               'Ofrecido por: $ownerName 👤',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Botón para solicitar intercambio -->

                          // trailing es un widget que se muestra al final del ListTile, ideal para acciones como botones de acción.
                          trailing: ElevatedButton.icon(
                            onPressed: () => _showRequestDialog( // Al hacer clic en el botón, se muestra un diálogo de solicitud de intercambio
                              context,
                              book,
                              ownerName,
                              colorScheme,
                            ),
                            icon: const Icon(Icons.handshake_outlined, size: 18),
                            label: const Text('Pedir'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
