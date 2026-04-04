import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/domain/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const BookCard({
    super.key,
    required this.book,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAvailable = book.status == 'disponible';

    // URL de portada automática via Open Library si tiene ISBN
    final String? coverUrl = (book.isbn != null && book.isbn!.isNotEmpty)
        ? 'https://covers.openlibrary.org/b/isbn/${book.isbn}-M.jpg'
        : null;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // PORTADA DEL LIBRO
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: coverUrl != null
                  ? Image.network(
                      coverUrl,
                      width: 60,
                      height: 85,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(colorScheme),
                    )
                  : _buildPlaceholder(colorScheme),
            ),
            const SizedBox(width: 12),

            // TÍTULO Y ESTADO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (book.isbn != null && book.isbn!.isNotEmpty)
                    Text(
                      'ISBN: ${book.isbn}',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: 6),
                  // BADGE DE ESTADO
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isAvailable ? '🤝 Disponible' : '📚 En mi estantería',
                      style: TextStyle(
                        fontSize: 11,
                        color: isAvailable
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BOTONES
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    isAvailable
                        ? Icons.handshake_outlined
                        : Icons.handshake,
                    color: colorScheme.primary,
                  ),
                  tooltip: isAvailable
                      ? 'Quitar de intercambio'
                      : 'Ofrecer para intercambio',
                  onPressed: onToggleStatus,
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: colorScheme.error),
                  tooltip: 'Eliminar libro',
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget placeholder cuando no hay portada
  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 60,
      height: 85,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.menu_book,
        color: colorScheme.primary,
        size: 30,
      ),
    );
  }
}
