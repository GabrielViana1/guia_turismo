import 'dart:convert';

import 'package:guia/services/api_config.dart';

import 'package:http/http.dart' as http;

class AuthService {
  final String url = '$baseUrl/login';

  Future<Map> autenticar(String email, String senha) async {
    final resposta = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({"email": email, "senha": senha}),
    );

    final Map<String, dynamic> corpo = jsonDecode(resposta.body);

    if (resposta.statusCode == 200) {
      return corpo['data'] ?? {};
    }

    return {'erro': corpo['message'] ?? 'Nao foi possivel entrar.'};
  }
}
