import 'package:flutter/material.dart';
import 'package:web_groupchat/ui/screen/home_screen.dart';

class GButton extends StatelessWidget {
  final String title;
  final bool isBusy;
  final void Function()? onPress;
  const GButton(
      {Key? key, this.isBusy = false, required this.title, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      onPressed: onPress,
      color: Colors.green.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: isBusy
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              )
            : Text(
                title,
                style: fontStyle.copyWith(color: Colors.white, fontSize: 14),
              ),
      ),
    );
  }
}
