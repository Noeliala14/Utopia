import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/books/domain/book_model.dart';

class BookRepository {
  final _supabase = Supabase.instance.client;

  // READ — obtiene todos los libros del usuario actual
  Future<List<BookModel>> fetchMyBooks() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final response = await _supabase
        .from('books_circulation')
        .select()
        .eq('original_owner_id', userId);

    return response.map((data) => BookModel.fromMap(data)).toList();
  }

  // CREATE — inserta un libro nuevo
  Future<void> addBook(BookModel book) async {
    await _supabase
        .from('books_circulation')
        .insert(book.toMap());
  }

  // UPDATE — cambia el estado del libro
  Future<void> updateBookStatus(String bookId, String newStatus) async {
    await _supabase
        .from('books_circulation')
        .update({'status': newStatus})
        .eq('id', bookId);
  }

  // DELETE — elimina el libro del catálogo
  Future<void> deleteBook(String bookId) async {
    await _supabase
        .from('books_circulation')
        .delete()
        .eq('id', bookId);
  }

  // RF-8 — libros disponibles de OTROS usuarios
  Future<List<BookModel>> fetchAvailableBooks() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final response = await _supabase
        .from('books_circulation')
        .select()
        .eq('status', 'disponible')
        .neq('original_owner_id', userId);

    return response.map((data) => BookModel.fromMap(data)).toList();
  }
}
