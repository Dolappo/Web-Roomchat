import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:web_groupchat/app/app_setup.locator.dart';
import 'package:web_groupchat/core/repo/user_repo.dart';
import 'package:web_groupchat/core/services/auth_service.dart';
import 'package:web_groupchat/core/services/firestore_service.dart';

import '../model/user_model.dart';

class UserService {
  final _auth = locator<AuthService>();
  final UserRepo _userRepo = UserRepo();
  final _store = FirestoreService();

  String get email => _auth.currentUser!.email!;
  String get username => _auth.currentUser!.displayName!;

  void createUser(UserModel user) async {
    await _userRepo.createUser(user.email!, user);
  }

  void uploadWebDp(Uint8List file) async {
    String? url = await _store.uploadWebImage(file, username: username);
    if (url != null) {
      _auth.updateUserPhotoUrl(url);
      _auth.currentUser!.reload();
    }
  }
}
