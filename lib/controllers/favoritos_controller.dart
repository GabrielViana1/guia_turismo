import 'package:flutter/foundation.dart';

import 'package:guia/services/favoritos_service.dart';

class FavoritosController extends ChangeNotifier {
  final FavoritosService _service = FavoritosService();

  bool carregando = false;

  String erro = '';

  List<int> _ids = [];

  FavoritosController() {
    listarFavoritos();
  }

  bool ehFavorito(int lugarId) {
    return _ids.contains(lugarId);
  }

  Future<void> listarFavoritos() async {
    carregando = true;
    erro = '';
    notifyListeners();

    try {
      _ids = await _service.buscarFavoritos();
    } catch (e) {
      erro = 'Erro ao carregar favoritos: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<String> alternarFavorito(int lugarId) async {
    try {
      if (ehFavorito(lugarId)) {
        await _service.remover(lugarId);
        _ids.remove(lugarId);
        notifyListeners();
        return 'Removido dos favoritos';
      }

      await _service.adicionar(lugarId);
      _ids.add(lugarId);
      notifyListeners();
      return 'Adicionado aos favoritos';
    } catch (e) {
      return 'Nao foi possivel alterar o favorito: $e';
    }
  }
}
