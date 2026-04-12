class Profile {
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final int booksExchanged;
  final bool isEcoHero;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  Profile({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.booksExchanged = 0,
    this.isEcoHero = false,
    this.createdAt,
    this.lastLogin,
  });

  //Supabase no tiene un sistema de roles tan robusto como Firebase, pero podemos simularlo 
  //con un campo adicional en el perfil del usuario. 
  //Por ejemplo, podríamos agregar un campo "role" que indique si el usuario es "admin",
  // "moderator" o "user". 
  //Esto nos permitiría controlar el acceso a ciertas funcionalidades de la aplicación según el rol del usuario.

factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id:         map['id'] ?? '',
      username:   map['user_name'] ?? '',
      email:      map['email'] ?? '',
      bio:        map['bio'],
      avatarUrl:  map['avatar_url'],
      booksExchanged: map['books_exchanged'] ?? 0,
      isEcoHero:  map['is_eco_hero'] ?? false,
      createdAt:  map['created_at'] != null 
                 ? DateTime.parse(map['created_at']) 
                 : null,
      lastLogin: map['last_login'] != null 
                 ? DateTime.parse(map['last_login']) 
                 : null,
    );
  }

  // Objeto Dart -> Supabase(Map<String, dynamic>)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': username,
      'email': email,
      'bio': bio,
      'avatar_url': avatarUrl,
      'books_exchanged': booksExchanged,
      'is_eco_hero': isEcoHero,
    };
  }
}