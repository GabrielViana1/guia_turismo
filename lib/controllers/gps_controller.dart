import 'package:flutter/foundation.dart';

import 'package:geolocator/geolocator.dart';

import 'package:guia/services/gps_service.dart';

class GpsController extends ChangeNotifier {
  final GpsService _service = GpsService();

  bool carregando = false;

  String erro = '';

  Position? posicao;

  GpsController() {
    buscarPosicao();
  }

  Future<void> buscarPosicao() async {
    carregando = true;
    erro = '';
    notifyListeners();

    try {
      posicao = await _service.pegarPosicao();
    } catch (e) {
      erro = 'Localizacao indisponivel: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  String? distanciaAte(double latitude, double longitude) {
    final atual = posicao;

    if (atual == null) {
      return null;
    }

    if (latitude.abs() > 90 || longitude.abs() > 180) {
      return null;
    }

    final metros = _service.distanciaEmMetros(
      atual.latitude,
      atual.longitude,
      latitude,
      longitude,
    );

    if (metros < 1000) {
      return '${metros.round()} m';
    }

    return '${(metros / 1000).toStringAsFixed(1)} km';
  }
}
