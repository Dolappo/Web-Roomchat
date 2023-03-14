import 'package:stacked_services/stacked_services.dart';

import '../../../app/app_setup.locator.dart';
import '../core/enum/ui_enums/bottomsheet_type.dart';
import 'bottomsheet/generic_bottom_sheet.dart';
import 'bottomsheet/generic_bottom_sheet_data_holders.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.Generic: (
      context,
      sheetRequest,
      Function(SheetResponse<GenericBottomSheetResponse>) completer,
    ) =>
        GenericBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
