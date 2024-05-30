import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageSourceSheet{
  // ImagePicker instance
  final picker = ImagePicker();

  Future<void> getImagefromGallery({
    required Function(File?) onImageSelected,
  }) async{
    // Get image from device gallery
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null){
      if (kDebugMode) {
        print('No image selected');
      }
      return;
    }
    // ignore: use_build_context_synchronously
    final image = File(pickedFile.path);

    // Check file
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      maxWidth: 700,
      maxHeight: 700,
    );
    
    final file = croppedImage != null ? File(croppedImage.path) : null;
    onImageSelected(file);
  
  }

}
