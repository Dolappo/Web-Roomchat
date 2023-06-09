import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app_setup.locator.dart';
import '../core/enum/ui_enums/snackbar_type.dart';

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  // Registers a config to be used when calling showSnackbar
  service.registerSnackbarConfig(SnackbarConfig(
    backgroundColor: Colors.red,
    textColor: Colors.white,
    mainButtonTextColor: Colors.black,
  ));
  service.registerCustomSnackbarConfig(
      variant: SnackbarType.errorMessage,
      config: SnackbarConfig(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        mainButtonTextColor: Colors.black,
      ));

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.blueAndYellow,
    config: SnackbarConfig(
      backgroundColor: Colors.blueAccent,
      textColor: Colors.yellow,
      borderRadius: 1,
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.greenAndRed,
    config: SnackbarConfig(
      backgroundColor: Colors.green,
      titleColor: Colors.white60,
      messageColor: Colors.white,
      borderRadius: 1,
    ),
  );
}
