import 'package:flutter/material.dart';


/*DrawersOne es un widget que representa una pantalla con un Drawer (menú lateral) */
class DrawersOne extends StatelessWidget {
  const DrawersOne({super.key});

  @override
  Widget build(BuildContext context) {

    // Drawer
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
          // logo 
           
              Icon(
                Icons.person,
                size: 70,
                color: Theme.of(context).colorScheme.primary,            
              )
              
          
      

          // Lista de opciones del menú
          
            
           // botón de perfil


          // opciones del menú

          // botón de configuración

          // botón de cerrar sesión
      
         ],
        ),
   
       ),
     
    );
  }
}
