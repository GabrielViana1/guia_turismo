class LugaresModel {
  final int id;

  final String nome;

  final String? categoria;

  final double latitude;
  final double longitude;

  final String descricao;

  final int categoriaId;

  final List<String> fotos;

  LugaresModel({
    this.id = 0,

    required this.nome,
    this.categoria,

    required this.latitude,
    required this.longitude,
    required this.categoriaId,
    this.descricao = '',
    this.fotos = const [],
  });

  bool get coordenadasValidas {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  String? get foto {
    if (fotos.isEmpty) {
      return null;
    }
    return fotos.first;
  }

  factory LugaresModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> galeria = json['galeria'] ?? [];

    return LugaresModel(
      id: json['id'],
      nome: json['nome'],

      categoria: json['categoria'] != null ? json['categoria']['nome'] : null,

      categoriaId: json['categoriaId'],

      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),

      descricao: json['descricao'] ?? '',

      fotos: galeria.map((item) => item['urlFoto'].toString()).toList(),
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
