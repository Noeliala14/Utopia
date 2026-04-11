import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/components/drawers_one.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _trendingBooks = [];
  List<Map<String, dynamic>> _newExchangeBooks = [];
  bool _isLoadingTrending = true;
  bool _isLoadingNew = true;

  // ── Trending Open Library ──
  Future<void> _fetchTrendingBooks() async {
    try {
      final response = await http.get(
        Uri.parse('https://openlibrary.org/trending/weekly.json?limit=12'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _trendingBooks = data['works'];
          _isLoadingTrending = false;
        });
      } else {
        setState(() => _isLoadingTrending = false);
      }
    } catch (e) {
      setState(() => _isLoadingTrending = false);
    }
  }

  // ── Novedades de intercambio desde Supabase ──
  Future<void> _fetchNewExchangeBooks() async {
    try {
      final response = await Supabase.instance.client
          .from('books_circulation')
          .select('*, propietario:original_owner_id (user_name)')
          .eq('status', 'disponible')
          .order('id', ascending: false) // ← los más recientes primero
          .limit(10);

      setState(() {
        _newExchangeBooks = List<Map<String, dynamic>>.from(response);
        _isLoadingNew = false;
      });
    } catch (e) {
      setState(() => _isLoadingNew = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTrendingBooks();
    _fetchNewExchangeBooks();
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
      body: CustomScrollView(
        slivers: [

          // ── SECCIÓN 1: NOVEDADES DE INTERCAMBIO ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  Icon(Icons.swap_horiz, color: colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Novedades de intercambio',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Text(
                'Libros que utópicos ofrecen ahora mismo',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // SCROLL HORIZONTAL de novedades
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: _isLoadingNew
                  ? const Center(child: CircularProgressIndicator())
                  : _newExchangeBooks.isEmpty
                      ? Center(
                          child: Text(
                            'Aún no hay libros disponibles',
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _newExchangeBooks.length,
                          itemBuilder: (context, index) {
                            final book = _newExchangeBooks[index];
                            final isbn = book['isbn'] as String?;
                            final coverUrl = isbn != null
                                ? 'https://covers.openlibrary.org/b/isbn/$isbn-M.jpg'
                                : null;
                            final title = book['title'] ?? 'Sin título';
                            final owner = book['propietario']?['user_name'] ?? 'Utópico';

                            return Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // PORTADA
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: coverUrl != null
                                        ? Image.network(
                                            coverUrl,
                                            width: 120,
                                            height: 140,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                _buildSmallPlaceholder(colorScheme),
                                          )
                                        : _buildSmallPlaceholder(colorScheme),
                                  ),
                                  const SizedBox(height: 6),
                                  // TÍTULO
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  // PROPIETARIO
                                  Text(
                                    owner,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ),

          // ── SECCIÓN 2: TENDENCIAS ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Tendencias esta semana',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 12),
              child: Text(
                'Descubre qué están leyendo otros lectores',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // GRID DE TENDENCIAS
          _isLoadingTrending
              ? const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = _trendingBooks[index];
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
                              // PORTADA — flex mayor para que se vea bien
                              Expanded(
                                flex: 8, // ← más espacio para la imagen
                                child: thumbnail != null
                                    ? Image.network(
                                        thumbnail,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (context, error, stackTrace) =>
                                            _buildPlaceholder(colorScheme),
                                      )
                                    : _buildPlaceholder(colorScheme),
                              ),

                              // INFO — flex menor para que no se coma la imagen
                              Expanded(
                                flex: 2, // ← menos espacio para el texto
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
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
                                        maxLines: 1, // ← solo 1 línea
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      if (author.isNotEmpty)
                                        Text(
                                          author,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: _trendingBooks.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // ← 3 columnas más estrechas
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Placeholder para las novedades horizontales
  Widget _buildSmallPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 120,
      height: 140,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.menu_book,
        size: 40,
        color: colorScheme.primary.withValues(alpha: 0.5),
      ),
    );
  }

  // Placeholder para el grid de tendencias
  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      color: colorScheme.primaryContainer,
      child: Icon(
        Icons.menu_book,
        size: 40,
        color: colorScheme.primary.withValues(alpha: 0.5),
      ),
    );
  }
}
