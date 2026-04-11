/// Clase de dominio para el sistema de roles.
/// 
/// Actualmente el control de acceso se gestiona mediante [Profile.isEcoHero].
/// Esta clase está preparada para futuras ampliaciones del sistema de permisos
/// basado en roles (RBAC).
/// 
/// Valores previstos para [nombreRol]: 'usuario', 'moderador', 'admin'
class Rol {
  int id;
  String nombreRol; //admin o usuario

  Rol({required this.id, 
  required this.nombreRol,
  });

  factory Rol.fromMap(Map<String, dynamic> map) {
    return Rol(
      id:        map['id'] ?? 0,
      nombreRol: map['nombre_rol'] ?? 'usuario',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':         id,
      'nombre_rol': nombreRol,
    };
  }
}