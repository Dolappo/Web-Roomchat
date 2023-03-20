import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:web_groupchat/app/app_setup.locator.dart';
import 'package:web_groupchat/core/enum/chat_type.dart';
import 'package:web_groupchat/core/enum/ui_enums/dialog_type.dart';
import 'package:web_groupchat/core/services/auth_service.dart';
import 'package:web_groupchat/core/services/group_service.dart';
import 'package:web_groupchat/core/services/image_picker_service.dart';
import 'package:web_groupchat/core/services/user_service.dart';
import '../../../core/model/chat.dart';
import '../../../core/model/chat_model.dart';
import '../../../core/services/chat_service.dart';

class HomeViewModel extends BaseViewModel {
  final _user = locator<UserService>();
  final _auth = locator<AuthService>();
  final _group = locator<GroupService>();
  final _dialog = locator<DialogService>();
  final _chat = locator<ChatService>();
  final _imgPicker = ImagePickerService();

  final String createGroupDth = "createGroup";
  final String addToGroupDth = "addToGroup";
  final String joinGroupDth = "joinGroup";
  final String leaveGroupDth = "leaveGroup";

  Uint8List? _userDp;
  Uint8List? _groupDp;

  Uint8List? get userDp => _userDp;
  Uint8List? get groupDp => _groupDp;

  User? get currentUser => _auth.currentUser;

  String get username => _user.username;

  bool get isAdmin => _group.isAdmin;

  GroupChatModel get selGroup => _group.selectedGroup!;

  bool viewGroupDetails = false;
  bool viewProfile = false;

  GroupChatModel? _selectedGroup;

  GroupChatModel? get selectedGroup => _selectedGroup;
  ChatType _groupType = ChatType.values.first;
  ChatType get groupType => _groupType;

  Stream<List<GroupChatModel>>? get groupStream => _group.groupStream;

  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  TextEditingController newUserController = TextEditingController();

  List<GroupChatModel> get publicGroups => _publicGroups;
  List<GroupChatModel> _publicGroups = [];

  final Map<String, StreamSubscription<List<ChatModel>>> chatStreams = {};
  final Map<String, List<ChatModel>> chatSnapshots = {};
  List<ChatModel> currChats = [];

  HomeViewModel() {
    _group.openGroupStream();
    getPublicGroups();
  }

  void closeGroupDetails() {
    viewGroupDetails = false;
    notifyListeners();
  }

  void openGroupDetails() {
    viewGroupDetails = true;
    notifyListeners();
  }

  onChangeType(ChatType type) {
    _groupType = type;
    notifyListeners();
  }

  void resumeSignal(GroupChatModel group, [bool justPausing = false]) {
    chatSnapshots[_selectedGroup!.id!] = currChats;
    if (!justPausing) currChats = chatSnapshots[group.id!] ?? [];
    notifyListeners();
  }

  bool isAMember(List<String> members) {
    return members.contains(_user.email);
  }

  void onSelectGroup(GroupChatModel group) {
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
        if (event.isEmpty) {
          currChats = [];
        }
        currChats = event;
        chatSnapshots[group.id!] = event;
        notifyListeners();
      });
    }
    _selectedGroup = group;
    _group.selectGroup = group;
    notifyListeners();
  }

  Future<void> sendMessage() async {
    ChatModel chat = ChatModel(
      sender: _user.username,
      text: chatController.text,
      time: DateTime.now(),
    );
    await _chat.sendChat(selectedGroup!.id!, chat);
    _group.updateLastMessage(chat, _selectedGroup!.id!);
    chatController.clear();
  }

  void setChatType(ChatType type) {
    _groupType = type;
    notifyListeners();
  }

  void onViewProfile() {
    viewProfile = true;
    notifyListeners();
  }

  void closeProfile() {
    viewProfile = false;
    if (_userDp != null) {
      _user.uploadWebDp(userDp!);
    }
    notifyListeners();
  }

  void pickUserDp() async {
    _userDp = await _imgPicker.pickWebImage();
    notifyListeners();
  }

  void pickGroupDp() async {
    _groupDp = await _imgPicker.pickWebImage();
    notifyListeners();
    if (_groupDp != null) {
      _selectedGroup!.dpUrl = await _group.uploadWebDp(_groupDp!);
      uploadDpToStore();
      notifyListeners();
    }
  }

  void getPublicGroups() async {
    _publicGroups = (await _group.getGroups())!;
    notifyListeners();
  }

  void showCreateDialog() async {
    await _dialog.showCustomDialog(
      variant: DialogType.createGroup,
      barrierDismissible: true,
    );
  }

  void showNewUserDialog() {
    _dialog.showCustomDialog(
        variant: DialogType.addMember, barrierDismissible: true);
  }

  Future<void> addToGroup() async {
    _selectedGroup = selGroup;
    if (_selectedGroup == null) {
    } else {
      _selectedGroup!.members!.add(newUserController.text);
      await runBusyFuture(
          _group.addUserToGroup(_selectedGroup!.members!, _selectedGroup!.id!),
          busyObject: addToGroupDth);
    }
  }

  void uploadDpToStore() async {
    await _group.updateGroupDp(_selectedGroup!.dpUrl!, _selectedGroup!.id!);
  }

  Future<void> joinGroup() async {
    _selectedGroup!.members!.add(_user.email);
    await runBusyFuture(
        _group.addUserToGroup(_selectedGroup!.members!, _selectedGroup!.id!),
        busyObject: joinGroupDth);
    _publicGroups = [];
    getPublicGroups();
    notifyListeners();
  }

  Future<void> leaveGroup() async {
    _selectedGroup!.members!.removeWhere((element) => element == _user.email);
    await runBusyFuture(
        _group.addUserToGroup(_selectedGroup!.members!, _selectedGroup!.id!));
    _publicGroups = [];
    notifyListeners();
    getPublicGroups();
  }

  Future<void> createGroup() async {
    _group.groupName = groupNameController.text;
    List<String> members = [_user.email];
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
