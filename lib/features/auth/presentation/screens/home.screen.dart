import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/components/drawers_one.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List books = [];
  bool isLoading = true;

  Future<void> fetchBooks() async {
    try {
      // Trending semanal de Open Library — se actualiza cada semana
      final response = await http.get(
        Uri.parse('https://openlibrary.org/trending/weekly.json?limit=12'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = data['works'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: const DrawersOne(),
      appBar: AppBar(
        title: Text(
          'U T O P Í A',
          style: TextStyle(
            color: colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        elevation: 4,
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CABECERA
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tendencias esta semana',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Descubre qué están leyendo otros lectores',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // GRID DE LIBROS
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final String? coverId = book['cover_id']?.toString() ??
                          book['cover_i']?.toString();
                      final String? thumbnail = coverId != null
                          ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
                          : null;
                      final String title = book['title'] ?? 'Sin título';
                      final String author = (book['authors'] != null &&
                              book['authors'].isNotEmpty)
                          ? book['authors'][0]['name'] ?? ''
                          : '';

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // PORTADA
                            Expanded(
                              flex: 7,
                              child: thumbnail != null
                                  ? Image.network(
                                      thumbnail,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (_, __, ___) =>
                                          _buildPlaceholder(colorScheme),
                                    )
                                  : _buildPlaceholder(colorScheme),
                            ),

                            // INFO DEL LIBRO
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? colorScheme.surfaceContainerHighest
                                      : colorScheme.surface,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    if (author.isNotEmpty) ...[
                                      const SizedBox(height: 3),
                                      Text(
                                        author,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      color: colorScheme.primaryContainer,
      child: Icon(
        Icons.menu_book,
        size: 50,
        color: colorScheme.primary.withValues(alpha: 0.5),
      ),
    );
  }
}