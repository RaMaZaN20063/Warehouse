import 'package:dmark_mobile_intership/data/hive_boxess.dart';
import 'package:dmark_mobile_intership/pages/product_list_page.dart';
import 'package:dmark_mobile_intership/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();

  runApp(
    BlocProvider(
      create: (_) => ThemeCubit()..loadTheme(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Warehouse',
          theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          themeMode: themeMode,
          home: const ProductListPage(),
        );
      },
    );
  }
}
