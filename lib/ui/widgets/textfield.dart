import 'package:flutter/material.dart';
import 'package:web_groupchat/ui/screen/home_screen.dart';

class GTextField extends StatelessWidget {
  final String? hintText;
  final Widget? prefix;
  final int? minLines;
  final int? maxLines;
  final void Function(String)? onChanged;
  final bool enableSuggestions;
  final bool isPassword;
  final void Function()? toggleVisibility;
  final TextEditingController? controller;
  final bool obscureText;
  final bool isBorder;
  final bool isEnabled;
  final TextInputAction? textInputAction;
  const GTextField(
      {this.isBorder = true,
      this.isEnabled = true,
      this.toggleVisibility,
      this.obscureText = false,
      this.isPassword = false,
      this.maxLines,
      this.textInputAction,
      this.enableSuggestions = false,
      this.onChanged,
      this.minLines,
      this.hintText,
      this.prefix,
      this.controller,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          enabled: isEnabled,
          textInputAction: textInputAction,
          obscureText: obscureText,
          style: fontStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              disabledBorder: isBorder
                  ? OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : InputBorder.none,
              enabledBorder: isBorder
                  ? OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : InputBorder.none,
              focusedBorder: isBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    )
                  : InputBorder.none,
              hintText: hintText,
              hintStyle: fontStyle.copyWith(fontSize: 12),
              prefixIcon: isPassword ? null : prefix,
              contentPadding: const EdgeInsets.all(20)),
          controller: controller,
          minLines: isPassword ? null : minLines,
          maxLines: isPassword ? 1 : maxLines,
          onChanged: onChanged,
          enableSuggestions: enableSuggestions,
        ),
        isPassword
            ? Positioned(
                right: 5,
                top: 5,
                child: IconButton(
                  onPressed: toggleVisibility,
                  icon: Icon(
                      !obscureText ? Icons.visibility_off : Icons.visibility),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
