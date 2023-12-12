import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "dart:async";

// StatefulWidget 정의
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // creatState함수는 state를 반환
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 조작을 위한 pageController 선언
  final PageController pageController = PageController();

  @override
  void initState() {
    // 부모 initState() 실행
    super.initState();

    // Timer.periodic() 등록
    Timer.periodic(Duration(seconds: 3), (timer) {
      // 현재 페이지 가져오기
      int? nextPage = pageController.page?.toInt();

      if (nextPage == null) {
        return;
      }

      if (nextPage == 4) {
        nextPage = 0;
      } else {
        nextPage++;
      }
      pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return (Scaffold(
      body: PageView(
          controller: pageController,
          children: [1, 2, 3, 4, 5]
              .map((number) => Image.asset(
                    "asset/img/image_$number.jpeg",
                    fit: BoxFit.cover,
                  ))
              .toList()),
    ));
  }
}
