import 'dart:typed_data';

import 'package:web_groupchat/core/repo/group_repo.dart';
import 'package:web_groupchat/core/services/user_service.dart';

import '../../app/app_setup.locator.dart';
import '../model/chat_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class GroupService {
  final _gRepo = GroupRepo();
  final _auth = locator<AuthService>();
  final _user = locator<UserService>();
  final _store = FirestoreService();

  String _groupName = "";

  String _groupUrl = "";
  String get groupUrl => _groupUrl;

  GroupChatModel? _selectedGroup;

  GroupChatModel? get selectedGroup => _selectedGroup;

  set selectGroup(GroupChatModel group) {
    _selectedGroup = group;
  }

  bool get isAdmin => _selectedGroup!.admin! == _user.email;

  set groupName(String gName) {
    _groupName = gName;
  }

  Stream<List<GroupChatModel>>? get groupStream => _gRepo.groupStream;

  void openGroupStream() async {
    await _gRepo.streamGroup(_user.email);
  }

  Future<List<GroupChatModel>?> getGroups() async {
    return await _gRepo.getPublicGroups(_user.email);
  }

  Future<void> createGroup(GroupChatModel group) async {
    group.id = groupId;
    group.admin = _user.email;
    await _gRepo.createGroup(group, groupId);
  }

  Future<void> addUserToGroup(List<String> members, String id) async {
    _gRepo.addUserToGroup(members, id);
  }

  Future<void> updateGroupDp(String url, id) async{
    await _gRepo.updateGroupDp(url, id);
  }

  Future<String?> uploadWebDp(Uint8List file) async {
    String? url = await _store.uploadWebImage(file, groupName: _groupName);
    if (url != null) {
      _groupUrl = url;
      return _groupUrl;
    }
  }

  String get groupId {
    return _user.email + _groupName.split(" ").last.toLowerCase();
  }
}
