import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'components/left/chat_lists.dart';
import 'components/left/profile.dart';
import 'components/middle.dart';
import 'components/right/group_info.dart';
import 'home_view_model.dart';

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
                Visibility(
                  visible: !model.viewProfile,
                  replacement: const Expanded(flex: 2, child: ProfileBox()),
                  child: Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.grey.shade100,
                        child: const ChatList(),
                      )),
                ),
                const Gap(5),
                Expanded(
                    flex: model.viewGroupDetails ? 2 : 5,
                    child: Container(
                      color: Colors.grey.shade100,
                      child: const MessageStream(),
                    )),
                Visibility(
                    visible: model.viewGroupDetails,
                    replacement: const SizedBox(),
                    child: const Expanded(flex: 2, child: GroupInfoBox()))
              ],
            ),
          );
        });
  }
}

TextStyle fontStyle = GoogleFonts.poppins(fontSize: 24);
