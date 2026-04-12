import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/books/domain/book_model.dart';

void main() {

  group('BookModel', () {

    test('fromMap convierte correctamente un Map a BookModel', () {
      // 1 — PREPARAS
      final map = {
        'id': '123',
        'title': '1984',
        'isbn': '978-0451524935',
        'status': 'disponible',
        'original_owner_id': 'abc',
      };

      // 2 — EJECUTAS
      final libro = BookModel.fromMap(map);

      // 3 — VERIFICAS
      expect(libro.id, '123');
      expect(libro.title, '1984');
      expect(libro.isbn, '978-0451524935');
      expect(libro.status, 'disponible');
      expect(libro.originalOwnerId, 'abc');
    });

    test('toMap convierte correctamente un BookModel a Map', () {
      // 1 — PREPARAS
      final libro = BookModel(
        id: '123',
        title: '1984',
        isbn: '978-0451524935',
        status: 'disponible',
        originalOwnerId: 'abc',
      );

      // 2 — EJECUTAS
      final map = libro.toMap();

      // 3 — VERIFICAS
      expect(map['title'], '1984');
      expect(map['isbn'], '978-0451524935');
      expect(map['status'], 'disponible');
      expect(map['original_owner_id'], 'abc');
    });

    test('fromMap maneja valores nulos correctamente', () {
      // 1 — PREPARAS — map sin datos opcionales
      final map = {
        'title': 'El principito',
        'original_owner_id': 'xyz',
      };

      // 2 — EJECUTAS
      final libro = BookModel.fromMap(map);

      // 3 — VERIFICAS
      expect(libro.title, 'El principito');
      expect(libro.isbn, null);   // ← null porque no venía en el map
      expect(libro.status, null); // ← null porque no venía en el map
    });

  });
}