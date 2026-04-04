import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/data/book_repository.dart';
import 'package:flutter_application_1/features/books/domain/book_model.dart';
import 'package:flutter_application_1/features/books/presentation/widgets/book_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final BookRepository _repo = BookRepository();
  late Future<List<BookModel>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _booksFuture = _repo.fetchMyBooks();
    });
  }

  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final isbnController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Añadir libro', style: TextStyle(color: colorScheme.primary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  prefixIcon: Icon(Icons.book),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: isbnController,
                decoration: const InputDecoration(
                  labelText: 'ISBN (opcional)',
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () async {
                if (titleController.text.trim().isEmpty) return;
                final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                final newBook = BookModel(
                  title: titleController.text.trim(),
                  isbn: isbnController.text.trim().isEmpty
                      ? null
                      : isbnController.text.trim(),
                  status: 'disponible',
                  originalOwnerId: userId,
                );
                await _repo.addBook(newBook);
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                _loadBooks();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBook(String bookId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          title: const Text('¿Eliminar libro?'),
          content: const Text('Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      await _repo.deleteBook(bookId);
      _loadBooks();
    }
  }

  Future<void> _toggleStatus(BookModel book) async {
    final newStatus =
        book.status == 'disponible' ? 'no disponible' : 'disponible';
    await _repo.updateBookStatus(book.id!, newStatus);
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Biblioteca',
          style: TextStyle(
              color: colorScheme.inversePrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBookDialog,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Añadir libro'),
      ),
      body: FutureBuilder<List<BookModel>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book,
                      size: 80,
                      color: colorScheme.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('Tu biblioteca está vacía',
                      style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Text('Pulsa + para añadir tu primer libro',
                      style: TextStyle(
                          color: colorScheme.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                book: book,
                onDelete: () => _deleteBook(book.id!),
                onToggleStatus: () => _toggleStatus(book),
              );
            },
          );
        },
      ),
    );
  }
}
