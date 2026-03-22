import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/components/drawers_one.dart';
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP
import 'dart:convert'; // Para decodificar JSON        

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override 
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //1º Variables.

  List books = []; // Lista para almacenar los libros obtenidos de la API
  bool isLoading = true;  // Para mostrar un indicador de carga

  //2º Funciones. 
 
  Future<void> fetchBooks() async { // Método asíncrono para obtener los libros de la API
    try { // URL de la API 
    final response = await http.get(Uri.parse('https://openlibrary.org/subjects/science_fiction.json?limit=10'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        books = data['works']; // Almacena los libros en la lista
        isLoading = false; // Cambia el estado de carga
      });

    } else {
      // Manejo de errores
      setState(() {
        isLoading = false; // Cambia el estado de carga incluso si hay un error
      });
      throw Exception('Failed to load books');
    }

   // Manejo de excepciones
    } catch (e) {
      setState(() {
        isLoading = false; // Cambia el estado de carga incluso si hay un error
      });
      // print('Error fetching books: $e');
    }
  }

  @override
  void initState() { //void initState() es un método del ciclo de vida de un StatefulWidget que se llama una vez cuando el widget se inserta en el árbol de widgets. Es el lugar ideal para realizar tareas de inicialización, como obtener datos o configurar controladores.
    super.initState(); //super.initState() siempre debe ser lo primero en initState para asegurarnos de que el estado se inicialice correctamente antes de realizar cualquier acción adicional.
    fetchBooks(); // fetchBooks() se llama dentro de initState para iniciar la obtención de datos tan pronto como el widget esté listo. Esto garantiza que los datos se carguen y estén disponibles para mostrar en la interfaz de usuario lo antes posible.
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; // Obtiene el esquema de colores actual del tema para usarlo en la interfaz de usuario
    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer:  DrawersOne(),
      appBar: AppBar(
        title:Text('Utopia',
        style: TextStyle(color: colorScheme.inversePrimary, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        
        backgroundColor: colorScheme.primary,
        elevation: 4,
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
      ),
      // El cuerpo de la pantalla muestra un indicador de carga o la lista de libros
      body: isLoading 
          ? const Center(child: CircularProgressIndicator()) // Muestra un indicador de carga mientras se obtienen los libros
          : Center(
              child: SizedBox(
                width: 800, // Ancho máximo para pantallas grandes
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:  3, // Tres columnas
                    childAspectRatio: 0.5, // Proporción de aspecto para las tarjetas
                    crossAxisSpacing: 15, // Espacio entre columnas
                    mainAxisSpacing: 15, // Espacio entre filas
            ),

            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final String? thumbnail = books[index]['cover_id'] != null 
                  ? 'https://covers.openlibrary.org/b/id/${books[index]['cover_id']}-M.jpg' 
                  : null; // URL de la imagen de portada, si está disponible
              return Card(
                color: colorScheme.secondary,
                elevation: 5, // Sombra para que destaque
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: thumbnail != null
                            ? Image.network(thumbnail, fit: BoxFit.cover, width: double.infinity)
                            : const Center(child: Icon(Icons.book, size: 50, color: Colors.grey)),
                      ),
                    Padding(
                        padding: const EdgeInsets.all(8.0), // Espacio alrededor del título
                        child: Text(
                          book['title'] ?? 'Sin título',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          
                       ),
                      ),
                    ],
                  ),
                ); //cierre card
              }, //cierre del itemBuilder
            ), //cierra GridView
          ), //cierra sizedbox
        ), //cierra del center
    );
  } // Cierre del método build
} // Cierre de la clase _HomeScreenState