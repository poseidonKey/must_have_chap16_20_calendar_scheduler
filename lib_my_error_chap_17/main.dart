import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:must_have_chap16_20_calendar_scheduler/database/drift_database.dart';
import 'package:must_have_chap16_20_calendar_scheduler/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final database = LocalDatabase(); // ➊ 데이터베이스 생성

  GetIt.I.registerSingleton<LocalDatabase>(database); // ➋ GetIt에

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomeScreen(),
    );
  }
}
