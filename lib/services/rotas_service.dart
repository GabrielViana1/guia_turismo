import 'package:url_launcher/url_launcher.dart';

class RotasService {
  Future<bool> abrirRota(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
    );

    return await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
