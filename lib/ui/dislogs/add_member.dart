import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:web_groupchat/ui/screen/home_view_model.dart';
import 'package:web_groupchat/ui/widgets/button.dart';
import 'package:web_groupchat/ui/widgets/textfield.dart';

import '../../app/app_setup.locator.dart';
import '../../core/enum/chat_type.dart';
import '../../setups/setup_dialog_ui.dart';

class AddMember extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse<GenericDialogResponse>) completer;
  const AddMember({Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 500.0, vertical: 200),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GTextField(
                      hintText: "Enter user's email",
                      controller: model.newUserController,
                      maxLines: 1,
                    ),
                    const Gap(20),
                    GButton(
                      title: "Add Member",
                      onPress: () async {
                        await model.addToGroup();
                        completer(DialogResponse(confirmed: true));
                      },
                      isBusy: model.busy(model.addToGroupDth),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
