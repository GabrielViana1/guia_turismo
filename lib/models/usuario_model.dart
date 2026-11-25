class UsuarioModel {
  final String nome;

  final String email;

  final String? foto;

  UsuarioModel({
    required this.nome,
    required this.email,
    this.foto,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'foto': foto,
    };
  }
}
