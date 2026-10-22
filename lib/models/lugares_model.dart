class LugaresModel {
  final int id;

  final String nome;

  final String? categoria;

  final double latitude;
  final double longitude;

  final String descricao;

  final int categoriaId;

  LugaresModel({
    this.id = 0,

    required this.nome,
    this.categoria,

    required this.latitude,
    required this.longitude,
    required this.categoriaId,
    this.descricao = '',
  });

  factory LugaresModel.fromJson(Map<String, dynamic> json) {
    return LugaresModel(
      id: json['id'],
      nome: json['nome'],

      categoria: json['categoria'] != null ? json['categoria']['nome'] : null,

      categoriaId: json['categoriaId'],

      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),

      descricao: json['descricao'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'latitude': latitude,
      'longitude': longitude,
      'categoriaId': categoriaId,
    };
  }
}
