import 'package:hive_flutter/adapters.dart';

class HiveBoxes {
  static const productBox = 'products';
  static const stocksBox = 'stocks';
  static const settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(productBox);
    await Hive.openBox(stocksBox);
    await Hive.openBox(settingsBox);
  }
}
