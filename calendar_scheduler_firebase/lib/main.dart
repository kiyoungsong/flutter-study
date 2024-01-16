import 'package:calendar_scheduler_firebase/firebase_options.dart';
import 'package:calendar_scheduler_firebase/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 파이어베이스 프로젝트 설정 함수
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // intl 패키지 초기화(다국어화)
  await initializeDateFormatting("ko_kr", null);

  // Provider 하위 위젯에 제공하기
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}
