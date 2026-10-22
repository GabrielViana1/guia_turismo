import 'dart:convert';

import 'package:guia/models/categoria_model.dart';

import 'package:guia/services/api_config.dart';

import 'package:http/http.dart' as http;

class CategoriasService {
  Future<List<CategoriaModel>> buscarCategorias() async {
    final resposta = await http.get(Uri.parse('$baseUrl/categorias'));

    if (resposta.statusCode == 200) {
      final Map<String, dynamic> corpo = jsonDecode(resposta.body);

      final List<dynamic> data = corpo['data'];

      return data.map((item) => CategoriaModel.fromJson(item)).toList();
    }

    throw Exception('Erro ao buscar categorias: ${resposta.body}');
  }
}
