import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:web_groupchat/utils/extension.dart';

import '../../../core/model/chat.dart';
import '../../screen/home/home_screen.dart';
import '../../screen/home/home_view_model.dart';

class ChatCard extends ViewModelWidget<HomeViewModel> {
  final bool isUser;
  final ChatModel model;
  const ChatCard({Key? key, this.isUser = false, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isUser ? Colors.green.shade800 : Colors.blueGrey.shade800,
            borderRadius: BorderRadius.only(
              topLeft: isUser ? const Radius.circular(15) : Radius.zero,
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
              topRight: isUser ? Radius.zero : const Radius.circular(15),
            )),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  model.sender!,
                  textAlign: TextAlign.start,
                  style: fontStyle.copyWith(fontSize: 12, color: Colors.green),
                ),
              ),
            Text(
              model.text!,
              style: fontStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            Gap(5),
            Text(
              model.time!.toTime(),
              style: fontStyle.copyWith(fontSize: 8, color: Colors.white54),
              textAlign: TextAlign.end,
            )
          ],
        ),
      ),
    );
  }
}
