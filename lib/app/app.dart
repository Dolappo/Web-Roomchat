import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:web_groupchat/setups/setup_dialog_ui.dart';

import '../setups/setup_bottom_sheet_ui.dart';
import '../setups/setup_snackbar_ui.dart';
import 'app_setup.locator.dart';

class App {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      // Replace with actual values
      options: const FirebaseOptions(
        apiKey: "AIzaSyAlrVGzAYuULAFoAnos-V9WQWyhmGn5JWI",
        appId: "1:209512169424:web:31a48f4500a76af50603d5",
        messagingSenderId: "209512169424",
        projectId: "web-groupchat",
        storageBucket: "web-groupchat.appspot.com",
        authDomain: "web-groupchat.firebaseapp.com",
      ),
    );
    setupLocator();
    setupBottomSheetUi();
    setupSnackbarUi();
    setupDialogUi();
  }
}
