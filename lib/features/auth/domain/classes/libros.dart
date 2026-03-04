class Libro {
  int id; 
  String titulo;
  String autor;
  String? isbn;
  String? descripcion;
  String? portadaUrl;
  int usuarioCreadorId;

  Libro({required this.id, 
        required this.titulo, 
        required this.autor, 
        this.isbn, 
        this.descripcion, 
        this.portadaUrl, 
        required this.usuarioCreadorId,
  
});
}
