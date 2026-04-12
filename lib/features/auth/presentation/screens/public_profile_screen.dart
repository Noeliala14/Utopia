import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PublicProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const PublicProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final _supabase = Supabase.instance.client;

  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>> _userBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Carga perfil del usuario
      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', widget.userId)
          .single();

      // Carga sus libros disponibles
      final books = await _supabase
          .from('books_circulation')
          .select()
          .eq('original_owner_id', widget.userId)
          .eq('status', 'disponible');

      setState(() {
        _profile = profile;
        _userBooks = List<Map<String, dynamic>>.from(books);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String username = _profile?['user_name'] ?? widget.userName;
    final String bio = _profile?['bio'] ?? 'Sin biografía';
    final int booksExchanged = _profile?['books_exchanged'] ?? 0;
    final bool isEcoHero = _profile?['is_eco_hero'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          username,
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
                    colorScheme.surface,
                  ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // AVATAR
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: colorScheme.primaryContainer,
                      child: username.isNotEmpty
                          ? Text(
                              username[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            )
                          : Icon(Icons.person,
                              size: 60, color: colorScheme.primary),
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

                    // ESTADÍSTICA
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

                    const SizedBox(height: 24),

                    // SUS LIBROS DISPONIBLES
                    if (_userBooks.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(Icons.menu_book,
                                color: colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Libros disponibles',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _userBooks.length,
                        itemBuilder: (context, index) {
                          final book = _userBooks[index];
                          final isbn = book['isbn'] as String?;
                          final coverUrl = isbn != null
                              ? 'https://covers.openlibrary.org/b/isbn/$isbn-M.jpg'
                              : null;

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: coverUrl != null
                                      ? Image.network(
                                          coverUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color:
                                                colorScheme.primaryContainer,
                                            child: Icon(Icons.menu_book,
                                                color: colorScheme.primary),
                                          ),
                                        )
                                      : Container(
                                          color: colorScheme.primaryContainer,
                                          child: Icon(Icons.menu_book,
                                              color: colorScheme.primary),
                                        ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      book['title'] ?? 'Sin título',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      Text(
                        'Este utópico no tiene libros disponibles aún.',
                        style:
                            TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}