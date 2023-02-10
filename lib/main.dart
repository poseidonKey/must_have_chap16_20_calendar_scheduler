import 'package:provider/provider.dart';
import '../screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../database/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'provider/schedule_provider.dart';
import 'repository/schedule_repository.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // runApp이 실행 되면 자동 실행 되지만 runApp 전에 아래 코드처럼 실행할 내용이 있는 경우 앱이 준비 될 때까지 미리 실행 시켜 준다.
  // flutter framework가 준비 되도록 한다.

  await initializeDateFormatting(); // 날짜에 관련 된 초기화

  final database = LocalDatabase(); // ➊ 데이터베이스 생성

  GetIt.I.registerSingleton<LocalDatabase>(database); // ➋ GetIt에
  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) {
        return scheduleProvider;
      },
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
