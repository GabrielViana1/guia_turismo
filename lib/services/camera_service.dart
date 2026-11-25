import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> chamarGaleria() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
    );
  }

  Future<XFile?> chamarCamera() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
    );
  }
}
