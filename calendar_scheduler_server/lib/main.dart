import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:get_it/get_it.dart";
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // intl 패키지 초기화(다국어화)
  await initializeDateFormatting("ko_kr", null);

  // DB 생성
  final database = LocalDatabase();

  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

  // GetIt에 데이터베이스 변수 주입
  GetIt.I.registerSingleton<LocalDatabase>(database);

  // Provider 하위 위젯에 제공하기
  runApp(ChangeNotifierProvider(
    create: (_) => scheduleProvider,
    child: MaterialApp(home: HomeScreen()),
  ));
}
