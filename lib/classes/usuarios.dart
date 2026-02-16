class Usuario {
  int id;
  String username;
  String email;
  String password;
  String? biografia;
  String? fotoPerfil;
  int rolesId;

  Usuario ({
    required this.id, 
    required this.username, 
    required this.email,
    required this.password,
    this.biografia,
    this.fotoPerfil,
    required this.rolesId,
  });
  
  String resumenPerfil() {
    return "$username, $biografia";
  }
}