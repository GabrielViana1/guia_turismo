import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _temaAtual = ThemeMode.system;

  ThemeMode get temaAtual => _temaAtual;

  bool get modoEscuro => _temaAtual == ThemeMode.dark;

  void alternarTema() {
    _temaAtual = modoEscuro ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void definirTema(ThemeMode tema) {
    _temaAtual = tema;
    notifyListeners();
  }
}
