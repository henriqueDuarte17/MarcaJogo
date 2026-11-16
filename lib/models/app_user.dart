enum UserRole {  //enum que define os tipos de utilizadores
  admin('Administrador'),
  player('Jogador'),
  manager('Gestor de clube');

  const UserRole(this.label);
  final String label;      //associa um texto a cada opção
}

class AppUser {  //classe que guarda os dados do utilizador
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isBlocked;
  final String? avatarUrl; //string? significa que o campo é opcional

  const AppUser({ //controi a classe "required" significa que é obrigatório
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isBlocked,
    this.avatarUrl,
  });
// converte o Json em objetos AppUser
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      // byName converte 'player' no valor UserRole.player
      role: UserRole.values.byName(json['role'] as String),
      isBlocked: json['is_blocked'] as bool,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}