import 'package:food_info_app/providers/barcode_provider.dart';
import 'package:food_info_app/utils/keys.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> providersAll = [
  ChangeNotifierProvider<BarcodeProvider>(
      create: (context) => BarcodeProvider()),
];

var provdBarcode =
    Provider.of<BarcodeProvider>(appKey.currentContext!, listen: false);
