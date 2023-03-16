import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:web_groupchat/app/app_setup.router.dart';
import 'package:web_groupchat/core/enum/auth_card.dart';
import 'package:web_groupchat/core/model/user_model.dart';
import 'package:web_groupchat/core/services/auth_service.dart';
import 'package:web_groupchat/core/services/user_service.dart';

import '../../../app/app_setup.locator.dart';

class AuthViewModel extends BaseViewModel {
  final _auth = locator<AuthService>();
  final _user = locator<UserService>();
  final _snack = locator<SnackbarService>();
  final _nav = locator<NavigationService>();
  final String busyIdt = "Busy";

  bool isVisible = true;

  void toggleVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  AuthCard get currentPage => _auth.currentPage;

  void setPage(AuthCard page) {
    _auth.authPage = page;
    notifyListeners();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  void login() async {
     await runBusyFuture(
        _auth.loginWithEmail(emailController.text, passwordController.text),
        busyObject: busyIdt);
    if (_auth.currentUser != null) {
      _snack.showSnackbar(message: "Successful");
      _nav.replaceWith(Routes.homeScreen);
    } else {
      _snack.showSnackbar(message: "failed");
    }
  }

  void register() async {
    var res = await runBusyFuture(
        _auth.registerWithEmail(emailController.text, passwordController.text,
            usernameController.text),
        busyObject: busyIdt);
    if (res != null) {
      _user.createUser(UserModel(
          email: emailController.text, username: usernameController.text));
      _snack.showSnackbar(message: "Registration Successful");
      _nav.replaceWith(Routes.homeScreen);
    } else {
      _snack.showSnackbar(message: "Invalid credentials");
    }
  }
}
