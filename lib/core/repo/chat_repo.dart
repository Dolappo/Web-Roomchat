import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_groupchat/core/model/chat.dart';

import '../services/firestore_service.dart';

class ChatRepo {
  final _fstore = FirestoreService();

  Stream<List<ChatModel>> streamGroup(String groupId) {
    print("chat Stream open");
    return _fstore
        .getGroupChatCollection(groupId)
        .orderBy("time")
        .snapshots()
        .map((event) {
      print("Events from chat stream: ${event.docs.first}");
      if (event.docs.isNotEmpty) {
        return event.docs.map((e) {
          ChatModel _chat = ChatModel.fromJson(e.data());
          print("Sender: ${_chat.sender}");
          // _log.i(_chat.sender);
          return _chat;
        }).toList();
      } else {
        return [];
      }
    });
  }

  Future<void> sendChat(ChatModel chat, String groupId) async {
    print(chat.text);
    DocumentReference docRef = _fstore.getGroupChatCollection(groupId).doc();
    chat.id = docRef.id;
    print(docRef.id);
    await _fstore.getGroupChatCollection(groupId).add(chat.toJson());
  }
}
