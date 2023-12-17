import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

// 상태관리를 위한 Stateful위젯 선언
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        // 시스템 UI 피해서 UI 그리기
        top: true,
        bottom: false,
        child: Column(
          // 위젯 맨위 아래로 위젯 배치
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // 가로 최대로 늘리기
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(
              onHeartPressed: onHeartPressed,
              firstDay: firstDay,
            ),
            _CoupleImage()
          ],
        ),
      ),
    ));
  }

  void onHeartPressed() {
    // 상태 변경 시 setState() 함수 실행

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        // 날짜 선택 다이얼로그
        final now = DateTime.now();
        return (Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 300,
              child: CupertinoDatePicker(
                // 시간 제외 후 날짜만 선택
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime date) {
                  setState(() {
                    firstDay = date;
                  });
                },
                initialDateTime: now,
                maximumDate: now,
              ),
            )));
      },
      // 외부 탭할 경우 다이얼로그 닫기
      barrierDismissible: true,
    );
  }
}

class _DDay extends StatelessWidget {
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  const _DDay({
    required this.onHeartPressed,
    required this.firstDay,
  });

  @override
  Widget build(BuildContext context) {
    // 테마 불러오기
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return (Column(
      children: [
        const SizedBox(height: 16.0),
        Text("U&I", style: textTheme.displayMedium),
        const SizedBox(height: 16.0),
        Text("우리 처음 만난 날", style: textTheme.bodyMedium),
        Text(
          "${firstDay.year}.${firstDay.month}.${firstDay.day}",
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 16.0),
        IconButton(
            iconSize: 60.0,
            onPressed: onHeartPressed,
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            )),
        const SizedBox(height: 16.0),
        Text(
          "D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}",
          style: textTheme.displaySmall,
        )
      ],
    ));
  }
}

class _CoupleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Image.asset(
        "asset/img/middle_image.png",
        // 화면의 반만큼 높이 구현, Expanded가 우선 순위를 갖게 되어 무시된다.
        height: MediaQuery.of(context).size.height / 2,
      ),
    ));
  }
}
