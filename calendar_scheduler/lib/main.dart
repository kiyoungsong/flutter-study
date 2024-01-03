import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // intl 패키지 초기화(다국어화)
  await initializeDateFormatting("ko_kr", null);
  runApp(MaterialApp(home: HomeScreen()));
}
