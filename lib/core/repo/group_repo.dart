import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_groupchat/core/model/chat.dart';
import 'package:web_groupchat/core/services/firestore_service.dart';

import '../enum/chat_type.dart';
import '../model/chat_model.dart';

class GroupRepo {
  final _fstore = FirestoreService();

  Future<List<GroupChatModel>?> getPublicGroups(String currentUser) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _fstore.groupCollection.where("type", isEqualTo: "public").get();

    return snapshot.docs
        .where((element) => !(element["members"] as List).contains(currentUser))
        .map((e) {
      GroupChatModel group = GroupChatModel.fromJson(e.data());
      return group;
    }).toList();
  }

  Future<void> createGroup(GroupChatModel group, String id) async {
    await _fstore.groupCollection.doc(id).set(group.toJson());
  }

  Future<void> addUserToGroup(List<String> members, String id) async {
    await _fstore.groupCollection
        .doc(id)
        .set({"members": members}, SetOptions(merge: true));
  }

  Future<void> updateGroupDp(String url, String id) async {
    await _fstore.groupCollection
        .doc(id)
        .set({"dpUrl": url}, SetOptions(merge: true));
  }

  Stream<List<GroupChatModel>>? groupStream;

  Future<List<GroupChatModel>?> streamGroup(String user) async {
    print("Stream open");
    groupStream = _fstore.groupCollection
        .where("members", arrayContains: user)
        // .orderBy("sendTime")
        .snapshots()
        .map((event) {
      print("Events from stream: ${event.docs.first}");
      if (event.docs.isNotEmpty) {
        return event.docs.map((e) {
          GroupChatModel _chat = GroupChatModel.fromJson(e.data());
          print("Members: ${_chat.members}");
          // _log.i(_chat.sender);
          return _chat;
        }).toList();
      } else {
        return [];
      }
    });
  }

  Future<void> setLastMessage(ChatModel chat, id) async {
    String lastMsg = chat.text!;
    String lastUpdatedTime = chat.time!.toIso8601String();
    await _fstore.groupCollection.doc(id).set(
        {"lastMssg": lastMsg, "lastUpdatedTime": lastUpdatedTime},
        SetOptions(merge: true));
  }
}
