import 'package:calendar_scheduler_firebase/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected; // 날짜 선택 시 실행할 함수
  final DateTime selectedDate; // 선택된 날짜

  const MainCalendar(
      {required this.onDaySelected, required this.selectedDate, super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "ko_kr",
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) {
        // 선택된 날짜를 구분할 로직
        return date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;
      },
      focusedDay: DateTime.now(),
      firstDay: DateTime(1900, 1, 1),
      lastDay: DateTime(2999, 12, 31),
      headerStyle: const HeaderStyle(
          // 달력 최상단 스타일
          titleCentered: true, // 제목 중앙에 위치하기
          formatButtonVisible: false, // 달력 크기 선택 옵션 없애기 2week
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0)),
      calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          defaultDecoration: BoxDecoration(
              // 기본 날짜 스타일
              borderRadius: BorderRadius.circular(6.0),
              color: LIGHT_GREY_COLOR),
          weekendDecoration: BoxDecoration(
            // 주말 날짜 스타일
            borderRadius: BorderRadius.circular(6.0),
            color: LIGHT_GREY_COLOR,
          ),
          selectedDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: PRIMARY_COLOR, width: 1.0)),
          defaultTextStyle:
              TextStyle(fontWeight: FontWeight.w600, color: DARK_GREY_COLOR),
          weekendTextStyle:
              TextStyle(fontWeight: FontWeight.w600, color: DARK_GREY_COLOR),
          selectedTextStyle: const TextStyle(
              fontWeight: FontWeight.w600, color: PRIMARY_COLOR)),
    );
  }
}
