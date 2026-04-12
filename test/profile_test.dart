import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/auth/domain/classes/profile.dart';

void main() {

  group('Profile', () {

    test('fromMap convierte correctamente un Map a Profile', () {
      final map = {
        'id': 'abc123',
        'user_name': 'Noelia',
        'email': 'noelia@gmail.com',
        'bio': 'Amante de los libros',
        'books_exchanged': 3,
        'is_eco_hero': true,
      };

      final profile = Profile.fromMap(map);

      expect(profile.id, 'abc123');
      expect(profile.username, 'Noelia');
      expect(profile.email, 'noelia@gmail.com');
      expect(profile.bio, 'Amante de los libros');
      expect(profile.booksExchanged, 3);
      expect(profile.isEcoHero, true);
    });

    test('toMap convierte correctamente un Profile a Map', () {
      final profile = Profile(
        id: 'abc123',
        username: 'Noelia',
        email: 'noelia@gmail.com',
        bio: 'Amante de los libros',
        booksExchanged: 3,
        isEcoHero: true,
      );

      final map = profile.toMap();

      expect(map['user_name'], 'Noelia');
      expect(map['email'], 'noelia@gmail.com');
      expect(map['bio'], 'Amante de los libros');
      expect(map['books_exchanged'], 3);
      expect(map['is_eco_hero'], true);
    });

    test('fromMap maneja valores nulos correctamente', () {
      final map = {
        'id': 'abc123',
        'user_name': 'Noelia',
        'email': 'noelia@gmail.com',
      };

      final profile = Profile.fromMap(map);

      expect(profile.bio, null);
      expect(profile.avatarUrl, null);
      expect(profile.booksExchanged, 0);   // ← valor por defecto
      expect(profile.isEcoHero, false);    // ← valor por defecto
    });

  });
}