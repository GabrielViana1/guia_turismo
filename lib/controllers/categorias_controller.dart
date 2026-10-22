import 'package:flutter/material.dart';

import 'package:guia/models/categoria_model.dart';

import 'package:guia/services/categorias_service.dart';

class CategoriasController extends ChangeNotifier {
  bool carregando = false;

  String erro = '';

  List<CategoriaModel> _categorias = [];
  List<CategoriaModel> get categorias => _categorias;

  CategoriasController() {
    listarCategorias();
  }

  Future<void> listarCategorias() async {
    carregando = true;
    erro = '';
    notifyListeners();

    try {
      _categorias = await CategoriasService().buscarCategorias();
    } catch (e) {
      erro = 'Erro ao listar categorias: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
