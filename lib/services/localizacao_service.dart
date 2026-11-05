import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:guia/models/local_model.dart';

import 'package:http/http.dart' as http;

class LocalizacaoService {
  Future<LocalModel?> buscarEndereco(String endereco) async {
    final resposta = await http.get(
      Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': endereco,
        'format': 'json',
        'limit': '1',
        'countrycodes': 'br',
      }),

      headers: kIsWeb ? {} : {'User-Agent': 'guia_turismo_fatec'},
    );

    if (resposta.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resposta.body);

      if (data.isEmpty) {
        return null;
      }

      return LocalModel.fromJson(data.first);
    }

    throw Exception('Erro na requisicao: ${resposta.statusCode}');
  }
}
