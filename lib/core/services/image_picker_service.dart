import 'dart:typed_data';
import 'dart:html' as html;

import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  html.File? _imageFile;
  String? _imageUrl;

  Future<XFile?> pickImage() async {
    XFile? selectedImg;
    selectedImg = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImg != null) {
      var f = await selectedImg.readAsBytes();
      return selectedImg;
    } else {
      print("No file selected");
    }
  }

  Future<Uint8List?> pickWebImage() async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    return image;
  }
}
