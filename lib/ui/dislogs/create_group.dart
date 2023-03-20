import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:web_groupchat/ui/widgets/button.dart';
import 'package:web_groupchat/ui/widgets/textfield.dart';

import '../../core/enum/chat_type.dart';
import '../../setups/setup_dialog_ui.dart';
import '../screen/home/home_view_model.dart';

class CreateGroupDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse<GenericDialogResponse>) completer;
  const CreateGroupDialog(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300.0, vertical: 200),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ViewModelBuilder<HomeViewModel>.reactive(
            viewModelBuilder: () => HomeViewModel(),
            builder: (context, model, _) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GTextField(
                      hintText: "Enter Group name",
                      controller: model.groupNameController,
                      maxLines: 1,
                    ),
                    const Gap(10),
                    GTextField(
                      hintText: "Group description...",
                      controller: model.groupDescController,
                      maxLines: 1,
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                              value: model.groupType,
                              items: List.generate(
                                  ChatType.values.length,
                                  (index) => DropdownMenuItem(
                                      value: ChatType.values[index],
                                      child: Text(ChatType.values[index]
                                          .capitalize()))),
                              onChanged: (type) => model.onChangeType(type!)),
                        ),
                        Gap(15),
                        Expanded(
                          child: GButton(
                            title: "Create",
                            onPress: () async {
                              await model.createGroup();
                              completer(DialogResponse(
                                confirmed: true,
                              ));
                            },
                            isBusy: model.busy(model.createGroupDth),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
