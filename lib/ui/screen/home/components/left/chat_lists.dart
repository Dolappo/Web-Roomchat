import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';

import '../../../../../core/model/chat_model.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/home/group_card.dart';
import '../../home_screen.dart';
import '../../home_view_model.dart';

class ChatList extends ViewModelWidget<HomeViewModel> {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(children: [
      Container(
        height: 65,
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: viewModel.onViewProfile,
                      child: CircleAvatar(
                        backgroundImage: viewModel.currentUser?.photoURL != null
                            ? NetworkImage(viewModel.currentUser!.photoURL!)
                            : null,
                      )),
                  Gap(10),
                  Text(
                    viewModel.username,
                    style: fontStyle.copyWith(fontSize: 18),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
        ),
      ),
      Gap(5),
      Expanded(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamBuilder<List<GroupChatModel>>(
                          stream: viewModel.groupStream,
                          builder: (context, snapshot) {
                            print(snapshot.data?.first.created);
                            if (snapshot.data != null) {
                              if (snapshot.hasData) {
                                List<GroupChatModel> data = snapshot.data!;
                                return Column(
                                  children: List.generate(data.length, (index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: GroupCard(
                                        onTap: () => viewModel
                                            .onSelectGroup(data[index]),
                                        model: data[index],
                                      ),
                                    );
                                  }),
                                );
                              } else {
                                return Expanded(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "Oops! you do not belong to a Group Chat",
                                            textAlign: TextAlign.center,
                                            style: fontStyle.copyWith(
                                                fontSize: 16),
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
                                style: fontStyle.copyWith(fontSize: 16),
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
                  Gap(10),
                  Text(
                    "Public Groups",
                    style: fontStyle.copyWith(
                        color: Colors.green.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Divider(),
                  Gap(5),
                  Column(
                    children:
                        List.generate(viewModel.publicGroups.length, (index) {
                      if (viewModel.publicGroups.isNotEmpty) {
                        return GroupCard(
                            onTap: () => viewModel
                                .onSelectGroup(viewModel.publicGroups[index]),
                            model: viewModel.publicGroups[index]);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
