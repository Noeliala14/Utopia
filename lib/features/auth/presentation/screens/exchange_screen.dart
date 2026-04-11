import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  List<Map<String, dynamic>> _availableBooks = [];
  bool _isLoading = true;

   
  Widget _buildBookPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 50,
      height: 70,
      color: colorScheme.primaryContainer,
      child: Icon(Icons.book, color: colorScheme.primary),
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
        .select('''*,propietario:current_owner_id (user_name)''')
        .eq('status', 'disponible')
        .neq('current_owner_id', currentUid ?? '');

    setState(() {
      _availableBooks = List<Map<String, dynamic>>.from(response);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                          subtitle: Text(
                            'Ofrecido por: $ownerName',
                            style:
                                TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                          trailing: Icon(Icons.handshake_outlined,
                              color: colorScheme.primary),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
