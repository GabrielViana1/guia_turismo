import 'dart:convert';

import 'package:guia/services/api_config.dart';

import 'package:http/http.dart' as http;

class FavoritosService {
  Map<String, String> get _cabecalhos {
    return {'Authorization': 'Bearer $token'};
  }

  Future<List<int>> buscarFavoritos() async {
    final resposta = await http.get(
      Uri.parse('$baseUrl/favoritos'),
      headers: _cabecalhos,
    );

    if (resposta.statusCode == 200) {
      final Map<String, dynamic> corpo = jsonDecode(resposta.body);

      final List<dynamic> data = corpo['data'] ?? [];

      final List<int> ids = [];

      for (final item in data) {
        final id = item['lugarId'] ?? item['lugar']?['id'] ?? item['id'];

        if (id is int) {
          ids.add(id);
        }
      }

      return ids;
    }

    throw Exception('Erro ao buscar favoritos (${resposta.statusCode})');
  }

  Future<void> adicionar(int lugarId) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/favoritos/$lugarId'),
      headers: _cabecalhos,
    );

    if (resposta.statusCode != 201 && resposta.statusCode != 200) {
      throw Exception('Erro ao favoritar (${resposta.statusCode})');
    }
  }

  Future<void> remover(int lugarId) async {
    final resposta = await http.delete(
      Uri.parse('$baseUrl/favoritos/$lugarId'),
      headers: _cabecalhos,
    );

    if (resposta.statusCode != 204 && resposta.statusCode != 200) {
      throw Exception('Erro ao remover favorito (${resposta.statusCode})');
    }
  }
}
