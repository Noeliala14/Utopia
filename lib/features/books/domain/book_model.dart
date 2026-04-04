class BookModel {
  final String? id; 
  final String title;
  final String? isbn;
  final String? status;
  final String originalOwnerId;

  BookModel({
    this.id,
    required this.title,
    this.isbn,
    this.status,
    required this.originalOwnerId,
  });

  // De Mapa (lo que viene de la tabla books_circulation) a Objeto de Dart
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'] ?? '',
      isbn: map['isbn'],
      status: map['status'],
      originalOwnerId: map['original_owner_id'] ?? '',
    );
  }

  // De Objeto de Dart a Mapa (para insertar en la tabla de Supabase)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isbn': isbn,
      'status': status,
      'original_owner_id': originalOwnerId,
    };
  }
}
