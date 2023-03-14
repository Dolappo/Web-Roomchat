
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:web_groupchat/core/services/chat_service.dart';
import 'package:web_groupchat/core/services/user_service.dart';
import 'package:web_groupchat/ui/screen/auth/auth_screen.dart';
import 'package:web_groupchat/ui/screen/home_screen.dart';

import '../core/services/auth_service.dart';
import '../core/services/group_service.dart';



@StackedApp(
  routes: [
    MaterialRoute(page: HomeScreen, initial: true),
    MaterialRoute(page: AuthScreen),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: GroupService),
    LazySingleton(classType: ChatService),
    // LazySingleton(classType: FireStorageService),
    // LazySingleton(classType: LocalStorage),
    // LazySingleton(classType: ImagePickerService),
    // LazySingleton(classType: ChatService),
   ],
  logger: StackedLogger(),
)
class $AppSetup {}
