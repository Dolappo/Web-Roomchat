import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/chat.dart';

class FirestoreService {
  final _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fStore = FirebaseFirestore.instance;
  final String messagesPath = "Messages";
  final String groupCollectionPath = "Groups";
  final String groupChatCollectionPath = "Chat";
  final String userCollectionPath = "Users";
  String? userEmail;
  Stream<List<ChatModel>>? chatStream;
  CollectionReference<Map<String, dynamic>> get messageCollection =>
      _fStore.collection(messagesPath);

  CollectionReference<Map<String, dynamic>> get groupCollection =>
      _fStore.collection(groupCollectionPath);

  CollectionReference<Map<String, dynamic>> get userCollection =>
      _fStore.collection(userCollectionPath);

  CollectionReference<Map<String, dynamic>> getGroupChatCollection(
      String groupId) {
    return groupCollection.doc(groupId).collection(groupChatCollectionPath);
  }

  Future<String?> uploadWebImage(Uint8List imageByte,
      {String? username, String? groupName}) async {
    print("Called to upload from Fstore");
    final String userPath = "Users/$username/dp/";
    final String groupPath = "Groups/$groupName/dp/";
    String imageUrl = '';
    try {
      print("Uploading Image");
      TaskSnapshot ref = await _storage
          .ref(groupName == null ? userPath : groupPath)
          .putData(imageByte);
      imageUrl = await ref.ref.getDownloadURL();
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      print(e);
    }
  }
}
