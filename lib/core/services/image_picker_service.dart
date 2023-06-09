import 'dart:html' as html;
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    XFile? selectedImg;
    selectedImg = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImg != null) {
      var f = await selectedImg.readAsBytes();
      return selectedImg;
    } else {
      print("No file selected");
      return null;
    }
  }

  Future<Uint8List?> pickWebImage() async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    return image;
  }
}
