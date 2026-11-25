import 'package:flutter/foundation.dart';

import 'package:guia/models/usuario_model.dart';

import 'package:guia/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool carregando = true;

  bool entrando = false;

  bool firebasePronto = false;

  String erro = '';

  UsuarioModel? usuario;

  AuthController() {
    iniciar();
  }

  Future<void> iniciar() async {
    try {
      await _authService.iniciar();
      firebasePronto = true;

      usuario = await _authService.usuarioLogado();
    } catch (e) {
      erro = 'Erro ao iniciar o Firebase: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> entrarComGoogle() async {
    if (!firebasePronto) {
      return;
    }

    entrando = true;
    erro = '';
    notifyListeners();

    try {
      usuario = await _authService.entrar();
    } catch (e) {
      erro = 'Login cancelado ou com erro: $e';
    } finally {
      entrando = false;
      notifyListeners();
    }
  }

  Future<void> sair() async {
    try {
      await _authService.sair();
    } catch (e) {
      debugPrint('$e');
    }

    usuario = null;
    notifyListeners();
  }
}
