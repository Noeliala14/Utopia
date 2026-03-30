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
      final response = await http.get(Uri.parse('https://openlibrary.org/subjects/science_fiction.json?limit=10'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = data['works'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load books');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: DrawersOne(),
      appBar: AppBar(
        title: Text('Utopia',
          style: TextStyle(color: colorScheme.inversePrimary, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        elevation: 4,
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SizedBox(
                width: 800,
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final String? thumbnail = books[index]['cover_id'] != null 
                        ? 'https://covers.openlibrary.org/b/id/${books[index]['cover_id']}-M.jpg' 
                        : null;
                    return Card(
                      color: colorScheme.secondary,
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: thumbnail != null
                                ? Image.network(thumbnail, fit: BoxFit.cover, width: double.infinity)
                                : const Center(child: Icon(Icons.book, size: 50, color: Colors.grey)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              book['title'] ?? 'Sin título',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}