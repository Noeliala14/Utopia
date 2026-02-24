import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const Drawer(),
         
      appBar: AppBar(title: const Text('Utopia')),
      body: const Center(child: Text('Bienvenido a Utopia')),
    );
  }
}