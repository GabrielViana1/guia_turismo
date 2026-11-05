import 'package:flutter/foundation.dart';

import 'package:guia/models/local_model.dart';

import 'package:guia/services/localizacao_service.dart';

class LocalizacaoController extends ChangeNotifier {
  bool carregando = false;

  String erro = "";

  LocalModel? local;

  Future<void> buscarEndereco(String endereco) async {
    carregando = true;
    erro = "";
    notifyListeners();

    try {
      final resultado = await LocalizacaoService().buscarEndereco(endereco);

      if (resultado == null) {
        erro = "Endereco nao encontrado!";
      } else {
        local = resultado;
      }
    } catch (e) {
      erro = "Erro ao buscar: $e";
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  void escolherPonto(double latitude, double longitude) {
    local = LocalModel(
      endereco: "Ponto escolhido no mapa",
      latitude: latitude,
      longitude: longitude,
    );
    erro = "";
    notifyListeners();
  }

  void limpar() {
    local = null;
    erro = "";
    notifyListeners();
  }
}
