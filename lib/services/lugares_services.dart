import 'dart:convert';

import 'package:guia/models/lugares_model.dart';

import 'package:guia/services/api_config.dart';

import 'package:http/http.dart' as http;

class LugaresServices {
  int pagina = 1;
  int limite = 1000;

  Future<List<LugaresModel>> buscarLugares() async {
    final resposta = await http.get(
      Uri.parse('$baseUrl/lugares?pagina=$pagina&limite=$limite'),
    );

    if (resposta.statusCode == 200) {
      final Map<String, dynamic> corpo = jsonDecode(resposta.body);

      final List<dynamic> data = corpo['data'];

      return data.map((item) => LugaresModel.fromJson(item)).toList();
    }

    throw Exception('Erro na requisicao: ${resposta.body}');
  }

  Future<String> cadastrarLugar(LugaresModel dados) async {
    if (token.isEmpty) {
      return 'Preencha o token em services/api_config.dart!';
    }

    final resposta = await http.post(
      Uri.parse('$baseUrl/lugares'),

      headers: {
        'Content-Type': 'application/json',

        'Authorization': 'Bearer $token',
      },

      body: jsonEncode(dados.toJson()),
    );

    if (resposta.statusCode == 201 || resposta.statusCode == 200) {
      return 'Lugar cadastrado com sucesso!';
    }

    final Map<String, dynamic> corpo = jsonDecode(resposta.body);

    return corpo['message'] ?? 'Erro ao cadastrar (${resposta.statusCode})';
  }
}
