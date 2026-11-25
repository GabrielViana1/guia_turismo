import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:guia/models/lugares_model.dart';

import 'package:guia/services/api_config.dart';

import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

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

      final List<LugaresModel> lugares = [];

      for (final item in data) {
        try {
          lugares.add(LugaresModel.fromJson(item));
        } catch (e) {
          debugPrint('Lugar ignorado por dados invalidos: ${item['id']}');
        }
      }

      return lugares;
    }

    throw Exception('Erro na requisicao: ${resposta.body}');
  }

  Future<String> cadastrarLugar(
    LugaresModel dados,
    Uint8List? foto,
    String nomeFoto,
  ) async {
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

    final Map<String, dynamic> corpo = jsonDecode(resposta.body);

    if (resposta.statusCode != 201 && resposta.statusCode != 200) {
      return corpo['message'] ?? 'Erro ao cadastrar (${resposta.statusCode})';
    }

    if (foto == null) {
      return 'Lugar cadastrado com sucesso!';
    }

    final lugar = corpo['data'] ?? corpo;
    final id = lugar['id'];

    if (id == null) {
      return 'Lugar cadastrado com sucesso, mas sem id para enviar a foto.';
    }

    final fotoEnviada = await enviarFoto(id, foto, nomeFoto);

    if (fotoEnviada) {
      return 'Lugar cadastrado com sucesso!';
    }

    return 'Lugar cadastrado com sucesso, mas a foto nao foi enviada.';
  }

  Future<bool> enviarFoto(int lugarId, Uint8List foto, String nomeFoto) async {
    final requisicao = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/lugares/$lugarId/galeria'),
    );

    requisicao.headers['Authorization'] = 'Bearer $token';

    requisicao.files.add(
      http.MultipartFile.fromBytes(
        'foto',
        foto,
        filename: nomeFoto,
        contentType: MediaType('image', _tipoDaImagem(nomeFoto)),
      ),
    );

    final resposta = await requisicao.send();

    return resposta.statusCode == 201 || resposta.statusCode == 200;
  }

  String _tipoDaImagem(String nomeFoto) {
    final nome = nomeFoto.toLowerCase();

    if (nome.endsWith('.png')) {
      return 'png';
    }

    if (nome.endsWith('.webp')) {
      return 'webp';
    }

    return 'jpeg';
  }
}
