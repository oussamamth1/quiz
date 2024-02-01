import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  static final _picker = ImagePicker();

  static Future<File?> pickImage() async {
    File? image;

    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } on PlatformException {
      throw PlatformAssetBundle();
    } catch (e) {
      throw Exception();
    }

    return image;
  }

  static Future<File?> takePhoto() async {
    File? image;

    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } on PlatformException {
      throw PlatformAssetBundle();
    } catch (e) {
      throw Exception();
    }

    return image;
  }

  static Future<File?> pickVideo() async {
    File? video;
    try {
      final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        video = File(pickedVideo.path);
      }
    } on PlatformException {
      throw PlatformAssetBundle();
    } catch (e) {
      throw Exception();
    }

    return video;
  }
}

enum Attachment {
  gallery,
  camera,
  online,
}
