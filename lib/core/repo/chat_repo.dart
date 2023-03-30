import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_groupchat/core/model/chat.dart';

import '../services/firestore_service.dart';

class ChatRepo {
  final _fstore = FirestoreService();

  Stream<List<ChatModel>> streamGroup(String groupId) {
    return _fstore
        .getGroupChatCollection(groupId)
        .orderBy("time")
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((e) {
          ChatModel chat = ChatModel.fromJson(e.data());
          return chat;
        }).toList();
      } else {
        return [];
      }
    });
  }

  Future<void> sendChat(ChatModel chat, String groupId) async {
    DocumentReference docRef = _fstore.getGroupChatCollection(groupId).doc();
    chat.id = docRef.id;
    await _fstore.getGroupChatCollection(groupId).add(chat.toJson());
  }
}
