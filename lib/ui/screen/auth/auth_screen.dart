import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:web_groupchat/ui/screen/auth/auth_view_model.dart';
import 'package:web_groupchat/ui/widgets/button.dart';
import 'package:web_groupchat/ui/widgets/textfield.dart';

import '../../../core/enum/auth_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: ()=> AuthViewModel(),
        builder: (context, model, _) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                height: 500,
                width: 500,
                child: Card(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: model.currentPage == AuthCard.register,
                          child: GTextField(
                            hintText: "Username",
                            controller: model.usernameController ,
                          ),
                        ),
                        Gap(10),
                        GTextField(
                          hintText: "Email",
                          controller: model.emailController ,
                        ),
                        const Gap(10),
                        GTextField(
                          hintText: "Password",
                          obscureText: model.isVisible,
                          isPassword: true,
                          controller: model.passwordController,
                          toggleVisibility: model.toggleVisibility,
                        ),
                        const Gap(20),
                          Visibility(
                            visible: model.currentPage==AuthCard.register,
                            child: GTextField(
                              hintText: "Password",
                              obscureText: model.isVisible,
                              isPassword: true,
                              controller: model.confirmPasswordController,
                              toggleVisibility: model.toggleVisibility,
                            ),
                          ),
                        const Gap(10),
                        GButton(
                            title:model.currentPage==AuthCard.login? "Login": "Register",
                            onPress: model.currentPage== AuthCard.login?model.login:model.register,
                            isBusy: model.busy(model.busyIdt)
                        ),
                        Gap(10),
                        Visibility(
                            visible: model.currentPage==AuthCard.login,
                        replacement: GestureDetector(
                          child: const Text("Login"),
                          onTap: ()=> model.setPage(AuthCard.login),
                        ),
                            child: GestureDetector(
                          onTap:()=> model.setPage(AuthCard.register),
                          child: const Text("Register here"),
                        ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
