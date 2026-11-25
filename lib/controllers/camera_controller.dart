import 'package:flutter/foundation.dart';

import 'package:guia/services/camera_service.dart';

import 'package:image_picker/image_picker.dart';

class CameraController extends ChangeNotifier {
  final CameraService _service = CameraService();

  bool carregando = false;

  String erro = '';

  Uint8List? imagemBytes;

  String nomeImagem = '';

  Future<void> abrirGaleria() async {
    await _escolher(_service.chamarGaleria);
  }

  Future<void> abrirCamera() async {
    await _escolher(_service.chamarCamera);
  }

  Future<void> _escolher(Future<XFile?> Function() abrir) async {
    carregando = true;
    erro = '';
    notifyListeners();

    try {
      final imagem = await abrir();

      if (imagem != null) {
        imagemBytes = await imagem.readAsBytes();
        nomeImagem = imagem.name;
      }
    } catch (e) {
      erro = 'Nao foi possivel abrir a imagem: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  void limpar() {
    imagemBytes = null;
    nomeImagem = '';
    erro = '';
    notifyListeners();
  }
}
