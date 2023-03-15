import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:web_groupchat/app/app_setup.locator.dart';
import 'package:web_groupchat/core/enum/chat_type.dart';
import 'package:web_groupchat/core/enum/ui_enums/dialog_type.dart';
import 'package:web_groupchat/core/model/user_model.dart';
import 'package:web_groupchat/core/services/group_service.dart';
import 'package:web_groupchat/core/services/user_service.dart';

import '../../core/model/chat.dart';
import '../../core/model/chat_model.dart';
import '../../core/services/chat_service.dart';

class HomeViewModel extends BaseViewModel {
  final _user = locator<UserService>();
  final _group = locator<GroupService>();
  final _dialog = locator<DialogService>();
  final _chat = locator<ChatService>();

  final String createGroupDth = "createGroup";
  final String addToGroupDth = "addToGroup";
  final String joinGroupDth = "joinGroup";
  final String leaveGroupDth = "leaveGroup";
  final Map<String, StreamSubscription<List<ChatModel>>> chatStreams = {};
  final Map<String, List<ChatModel>> chatSnapshots = {};
  List<ChatModel> currChats = [];

  HomeViewModel() {
    _group.openGroupStream();
    getPublicGroups();
  }

  bool get isAmin => _group.isAdmin;

  GroupChatModel get selGroup => _group.selectedGroup!;

  bool viewGroupDetails = false;

  void closeGroupDetails() {
    viewGroupDetails = false;
    notifyListeners();
  }

  void openGroupDetails() {
    viewGroupDetails = true;
    notifyListeners();
  }

  UserModel? get user => _user.user;

  ChatType _groupType = ChatType.values.first;

  ChatType get groupType => _groupType;

  onChangeType(ChatType type) {
    _groupType = type;
    notifyListeners();
  }

  GroupChatModel? _selectedGroup;

  GroupChatModel? get selectedGroup => _selectedGroup;

  void resumeSignal(GroupChatModel group, [bool justPausing = false]) {
    print("Current Chats: $currChats");
    chatSnapshots[_selectedGroup!.id!] = currChats;
    if (!justPausing) currChats = chatSnapshots[group.id!] ?? [];
    notifyListeners();
  }

  bool isAMember(List<String> members) {
    return members.contains(_user.user!.email!);
  }

  void onSelectGroup(GroupChatModel group) {
    print("Chat Snapshots: $chatSnapshots");
    print("Chat Streams: $chatStreams");
    if (chatStreams[group.id!] != null) {
      chatStreams[_selectedGroup!.id!]!.pause();
      chatStreams[group.id!]!.resume();
      resumeSignal(group);
    } else {
      if (_selectedGroup != null) {
        chatStreams[_selectedGroup!.id!]!.pause();
        resumeSignal(group, true);
      }
      chatStreams[group.id!] = _chat.openChatStream(group.id!).listen((event) {
        print("Group ID${group.id}");
        if (event.isEmpty) {
          currChats = [];
        }
        currChats = event;
        chatSnapshots[group.id!] = event;
        notifyListeners();
      });
    }
    // _chat.openChatStream(selectedGroup!.id!);
    _selectedGroup = group;
    _group.selectGroup = group;
    notifyListeners();
  }

  Future<void> sendMessage() async {
    await _chat.sendChat(
        selectedGroup!.id!,
        ChatModel(
          sender: currentUser,
          text: chatController.text,
          time: DateTime.now(),
        ));
  }

  String? get currentUser => _user.user!.email!;

  Stream<List<GroupChatModel>>? get groupStream => _group.groupStream;

  // ChatType _groupType = ChatType.public;
  //
  // ChatType get groupType => _groupType;

  void setChatType(ChatType type) {
    _groupType = type;
    notifyListeners();
  }

  bool viewProfile = false;

  void onViewProfile() {
    viewProfile = true;
    notifyListeners();
  }

  void closeProfile() {
    viewProfile = false;
    notifyListeners();
  }

  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescController = TextEditingController();

  TextEditingController chatController = TextEditingController();

  String get username => _user.user?.username ?? "";

  List<GroupChatModel> get publicGroups => _publicGroups;

  List<GroupChatModel> _publicGroups = [];

  void getPublicGroups() async {
    _publicGroups = (await _group.getGroups())!;
    print("Public Groupssss ${_publicGroups.first.name}");
    notifyListeners();
  }

  void showCreateDialog() async {
    await _dialog.showCustomDialog(
      variant: DialogType.createGroup,
      barrierDismissible: true,
    );
  }

  TextEditingController newUserController = TextEditingController();

  void showNewUserDialog() {
    _dialog.showCustomDialog(
        variant: DialogType.addMember, barrierDismissible: true);
  }

  Future<void> addToGroup() async {
    _selectedGroup = selGroup;
    if (_selectedGroup == null) {
      print("The selected group is null");
    } else {
      print("Existing List: ${_selectedGroup!.members!.toString()}");
      _selectedGroup!.members!.add(newUserController.text);
      print("Updated List: ${_selectedGroup!.members!.toString()}");
      await runBusyFuture(
          _group.addUserToGroup(_selectedGroup!.members!, _selectedGroup!.id!),
          busyObject: addToGroupDth);
    }
  }

  Future<void> joinGroup() async {
    _selectedGroup!.members!.add(_user.user!.email!);
    await runBusyFuture(
        _group.addUserToGroup(_selectedGroup!.members!, _selectedGroup!.id!),
        busyObject: joinGroupDth);
    _publicGroups = [];
    getPublicGroups();
    notifyListeners();
  }

  Future<void> leaveGroup() async {
    _selectedGroup!.members!
        .removeWhere((element) => element == _user.user!.email!);
    await runBusyFuture(
        _group.addUserToGroup(_selectedGroup!.members!, _selectedGroup!.id!));
    _selectedGroup = null;
    _publicGroups = [];
    notifyListeners();
    getPublicGroups();
  }

  Future<void> createGroup() async {
    _group.groupName = groupNameController.text;
    List<String> members = [_user.user!.email!];
    await runBusyFuture(
        _group.createGroup(GroupChatModel(
          desc: groupDescController.text,
          name: groupNameController.text,
          created: DateTime.now(),
          type: groupType,
          members: members,
        )),
        busyObject: createGroupDth);
  }

  @override
  void dispose() {
    super.dispose();
    for (var element in chatStreams.values) {
      element.cancel();
    }
  }
}
