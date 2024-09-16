import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/ui/navition/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MainNavigation mainNavigation = MainNavigation();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: MainNavigation.mainRoutes,
      initialRoute: MainNavigation.initialRoute,
      onGenerateRoute: MainNavigation.onGenerateRoute,
    );
  }
}
