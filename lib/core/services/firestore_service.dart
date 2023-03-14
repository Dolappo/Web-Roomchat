import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_groupchat/core/model/chat_model.dart';

import '../model/chat.dart';

class FirestoreService {
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

  Future<List<ChatModel>?> streamMessages(String chatPartnerMail) async {
    print("User email: $userEmail");
    chatStream = _fStore
        .collection(messagesPath)
        // .orderBy("timeStamp")
        .where("user", whereIn: [chatPartnerMail, userEmail!])
        .snapshots()
        .map((event) {
          if (event.docs.isNotEmpty) {
            return event.docs.map((e) {
              print('Chats: ${e.data()}');
              ChatModel _chat = ChatModel.fromJson(e.data());
              return _chat;
            }).toList();
          } else {
            return [];
          }
        });
  }
}
