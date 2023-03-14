import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:web_groupchat/core/model/chat_model.dart';
import 'package:web_groupchat/ui/screen/home_view_model.dart';
import 'package:web_groupchat/ui/widgets/textfield.dart';
import 'package:web_groupchat/utils/extension.dart';

import '../../core/model/chat.dart';
import '../widgets/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, _) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.grey.shade100,
                      child: ChatList(),
                    )),
                Gap(5),
                Expanded(
                    flex: 5,
                    child: Container(
                      color: Colors.grey.shade100,
                      child: MessageStream(),
                    ))
              ],
            ),
          );
        });
  }
}

class ChatList extends ViewModelWidget<HomeViewModel> {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(children: [
      Container(
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(),
            Text(viewModel.username),
            Row(
              children: List.generate(
                  4,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {}, icon: Icon(Icons.access_time)),
                      )),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 2,
      ),
      Expanded(
        child: Column(
          children: [
            StreamBuilder<List<GroupChatModel>>(
                stream: viewModel.groupStream,
                builder: (context, snapshot) {
                  print(snapshot.data?.first.created);
                  if (snapshot.data != null) {
                    if (snapshot.hasData) {
                      List<GroupChatModel> data = snapshot.data!;
                      return ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GroupCard(
                                onTap:()=> viewModel.onSelectGroup(data[index]),
                                model: data[index],
                              ),
                            );
                          });
                    } else {
                      return Expanded(
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Oops! you do not belong to a Group Chat",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Text(
                      "Oops! you do not belong to a Group Chat",
                      textAlign: TextAlign.center,
                    );
                  }
                }),
            Gap(20),
            GButton(
              title: "Create Group",
              onPress: viewModel.showCreateDialog,
            ),
          ],
        ),
      )
    ]);
  }
}

class MessageStream extends ViewModelWidget<HomeViewModel> {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    if (viewModel.selectedGroup != null) {
      return Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: ListTile(
              leading: CircleAvatar(),
              title: Text(viewModel.selectedGroup!.name!),
              subtitle: Text(viewModel.selectedGroup!.desc!),
              trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                    builder: (context) {
                      if (viewModel.currChats.isNotEmpty) {
                        return Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: viewModel.currChats.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ChatCard(
                                    model: viewModel.currChats[index],
                                    isUser: viewModel.currChats[index].sender ==
                                        viewModel.currentUser,
                                  ),
                                );
                              }),
                        );
                      } else {
                        return const Center(
                          child: Text("Start a chat"),
                        );
                      }
                    }),
                Stack(
                  children: [
                    GTextField(
                      hintText: "Message...",
                      controller: viewModel.chatController,
                    ),
                    Positioned(
                        right: 5,
                        bottom: 5,
                        child: IconButton(
                            onPressed: viewModel.sendMessage,
                            icon: const Icon(Icons.send))),
                  ],
                )
              ],
            ),
          )
        ],
      );
    } else {
      return const Center(
        child: Text("Welcome"),
      );
    }
  }
}

class GroupCard extends StatelessWidget {
  final GroupChatModel model;
  final void Function()? onTap;
  const GroupCard({Key? key, required this.model, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(),
        title: Text(model.name!),
        subtitle: Text(model.lastMssg ?? "-"),
        trailing: Column(
          children: [
            Text(model.lastUpdatedTime?.toTime() ??
                model.created?.toTime() ??
                "-"),
          ],
        ),
      ),
    );
  }
}

class ChatCard extends ViewModelWidget<HomeViewModel> {
  final bool isUser;
  final ChatModel model;
  const ChatCard({Key? key, this.isUser = false, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Align(
      alignment: isUser?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isUser ? Colors.green.shade800 : Colors.black54,
            borderRadius: BorderRadius.only(
              topLeft: isUser ? const Radius.circular(15) : Radius.zero,
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
              topRight: isUser ? Radius.zero : const Radius.circular(15),
            )),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(model.text!),
            Gap(10),
            Text(
              model.time!.toTime(),
              style: const TextStyle(fontSize: 8),
              textAlign: TextAlign.right,
            )
          ],
        ),
      ),
    );
  }
}
