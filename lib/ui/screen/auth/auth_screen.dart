import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:web_groupchat/ui/screen/auth/auth_view_model.dart';
import 'package:web_groupchat/ui/screen/home/home_screen.dart';
import 'package:web_groupchat/ui/widgets/button.dart';
import 'package:web_groupchat/ui/widgets/textfield.dart';

import '../../../core/enum/auth_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: () => AuthViewModel(),
        builder: (context, model, _) {
          return Scaffold(
            body: Stack(
              children: [
                Opacity(
                  opacity: 0.05,
                  child: Image.asset(
                    "assets/bg.jpg",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  // decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //       opacity: 0.05,
                  //       image: AssetImage("assets/bg.jpg"),
                  //       fit: BoxFit.cover),
                  // ),
                  // padding: EdgeInsets.symmetric(horizontal: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        height: 80,
                      ),
                      Gap(10),
                      Text(
                        model.currentPage == AuthCard.register
                            ? "Create an Account"
                            : "Welcome Back",
                        style: fontStyle.copyWith(
                            color: Colors.green.shade800,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                      Gap(5),
                      SizedBox(
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: model.currentPage == AuthCard.register,
                              child: GTextField(
                                hintText: "Username",
                                controller: model.usernameController,
                              ),
                            ),
                            Gap(10),
                            GTextField(
                              hintText: "Email",
                              controller: model.emailController,
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
                              visible: model.currentPage == AuthCard.register,
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
                                title: model.currentPage == AuthCard.login
                                    ? "Login"
                                    : "Register",
                                onPress: model.currentPage == AuthCard.login
                                    ? model.login
                                    : model.register,
                                isBusy: model.busy(model.busyIdt)),
                            Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: model.signInWithGoogle,
                                  child: Text(
                                    "Sign in with Google",
                                    style: fontStyle.copyWith(fontSize: 18),
                                  ),
                                ),
                                Visibility(
                                  visible: model.currentPage == AuthCard.login,
                                  replacement: GestureDetector(
                                    child: Text(
                                      "Login here",
                                      style: fontStyle.copyWith(
                                          color: Colors.green.shade800,
                                          fontSize: 16),
                                    ),
                                    onTap: () => model.setPage(AuthCard.login),
                                  ),
                                  child: GestureDetector(
                                    onTap: () =>
                                        model.setPage(AuthCard.register),
                                    child: Text("Register here",
                                        style: fontStyle.copyWith(
                                            color: Colors.green.shade800,
                                            fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
