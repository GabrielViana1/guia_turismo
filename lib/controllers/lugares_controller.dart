import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:guia/models/lugares_model.dart';

import 'package:guia/services/lugares_services.dart';

class LugaresController extends ChangeNotifier {
  bool carregando = false;

  String erro = "";

  List<LugaresModel> _lugares = [];

  List<LugaresModel> get lugares => _lugares;

  LugaresController() {
    listarLugares();
  }

  Future<void> listarLugares() async {
    carregando = true;
    notifyListeners();

    try {
      final lugaresService = LugaresServices();
      final listaLugares = await lugaresService.buscarLugares();
      _lugares = listaLugares;
      erro = "";
    } catch (error) {
      erro = "Erro ao listar: $error";
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<String> cadastrarLugar(
    LugaresModel dados,
    Uint8List? foto,
    String nomeFoto,
  ) async {
    carregando = true;
    erro = "";
    notifyListeners();

    try {
      final lugaresService = LugaresServices();

      final resposta = await lugaresService.cadastrarLugar(
        dados,
        foto,
        nomeFoto,
      );

      final listaLugares = await lugaresService.buscarLugares();
      _lugares = listaLugares;

      return resposta;
    } catch (e) {
      erro = "Erro ao cadastrar: $e";
      return erro;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
