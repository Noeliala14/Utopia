# flutter_application_1

# Utopía — App de Intercambio de Libros

Proyecto de Fin de Ciclo — Desarrollo de Aplicaciones Multiplataforma  
Alumna: Noelia Lázaro Gómez | Tutora: Luz María Álvarez Moreno  
Prometeo / ThePower FP Oficial — 2026

---

## Descripción

Utopía es una aplicación móvil multiplataforma desarrollada con Flutter 
que permite a los usuarios gestionar su biblioteca personal de libros 
físicos e intercambiarlos con otros lectores mediante un modelo de 
economía circular.

---

## Funcionalidades implementadas

- Registro e inicio de sesión con Firebase Authentication
- Modo claro/oscuro con esquema de colores Sakura (FlexColorScheme)
- Catálogo de libros en tendencia semanal via API Open Library
- CRUD completo de biblioteca personal con Supabase
- Sistema de gamificación automático (Badge Eco Héroe via trigger PostgreSQL)
- Perfil de usuario con avatar generado dinámicamente
- Visualización de libros disponibles de otros usuarios

---

## Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| Flutter + Dart | Framework principal multiplataforma |
| Firebase Auth | Autenticación de usuarios |
| Supabase (PostgreSQL) | Base de datos y backend |
| Open Library API | Catálogo bibliográfico externo |
| FlexColorScheme | Sistema de temas visuales |
| Provider | Gestión de estado global |

---

## Instalación y ejecución

### Requisitos previos
- Flutter SDK (versión estable)
- JDK 17
- Android 5.0 (API 21) o superior

### Pasos
1. Clona el repositorio
   git clone https://github.com/Noeliala14/Utopia.git

2. Instala las dependencias
   flutter pub get

3. Configura las credenciales de Supabase
   Copia el archivo: lib/core/supabase_conf.dart/configuracion.example.dart
   Renómbralo a: configuracion.dart
   Añade tu URL y clave anónima de Supabase

4. Ejecuta la app
   flutter run

### Instalación directa (APK)
Disponible el APK compilado para instalación directa en Android.
Activa "Fuentes desconocidas" en ajustes de seguridad de tu dispositivo.

---

##  Credenciales de prueba

Para acceder a la app sin registrarse:

Email: prueba1004@gmail.com  
Contraseña: [contactar con la autora]

---

## Arquitectura

El proyecto sigue Clean Architecture con enfoque Feature-First:

```
lib/
├── core/
│   ├── themes/           # light_mode, dark_mode, theme_provider
│   └── supabase_conf/    # configuración de Supabase
├── features/
│   ├── auth/
│   │   ├── data/         # auth_service
│   │   ├── domain/       # clases de dominio
│   │   └── presentation/ # pantallas y componentes
│   └── books/
│       ├── data/         # book_repository
│       ├── domain/       # book_model
│       └── presentation/ # books_screen, book_card
└── main.dart
```

---

## Estado del proyecto

 MVP funcional entregado  
 Pendiente: flujo completo de confirmación de intercambio  
 Pendiente: chat en tiempo real  
 Pendiente: activación de Row Level Security (RLS) en producción  

---

## Bibliografía principal

- Google Flutter Docs: https://docs.flutter.dev
- Firebase Auth: https://firebase.google.com/docs/auth
- Supabase Docs: https://supabase.com/docs
- Open Library API: https://openlibrary.org/developers/api
- Martin, R. C. (2018). Clean Architecture. Prentice Hall.
