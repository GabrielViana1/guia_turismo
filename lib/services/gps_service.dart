import 'package:geolocator/geolocator.dart';

class GpsService {
  Future<Position> pegarPosicao() async {
    final ligado = await Geolocator.isLocationServiceEnabled();

    if (!ligado) {
      throw Exception('O GPS do aparelho esta desligado.');
    }

    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      throw Exception('Permissao de localizacao negada.');
    }

    return await Geolocator.getCurrentPosition();
  }

  double distanciaEmMetros(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    return Geolocator.distanceBetween(
      latitude1,
      longitude1,
      latitude2,
      longitude2,
    );
  }
}
