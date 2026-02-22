import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageSourceSheet {
  final picker = ImagePicker();

  Future<void> getImagefromGallery({
    required Function(File?) onImageSelected,
  }) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      if (kDebugMode) print('No image selected');
      return;
    }
    final image = File(pickedFile.path);

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      maxWidth: 700,
      maxHeight: 700,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        IOSUiSettings(
          title: 'Recortar',
          aspectRatioLockEnabled: false,
        ),
      ],
    );

    final file = (croppedFile != null) ? File(croppedFile.path) : null;
    onImageSelected(file);
  }
}