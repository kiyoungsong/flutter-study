import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:get_it/get_it.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // intl 패키지 초기화(다국어화)
  await initializeDateFormatting("ko_kr", null);

  // DB 생성
  final database = LocalDatabase();
  // GetIt에 데이터베이스 변수 주입
  GetIt.I.registerSingleton<LocalDatabase>(database);
  runApp(MaterialApp(home: HomeScreen()));
}
