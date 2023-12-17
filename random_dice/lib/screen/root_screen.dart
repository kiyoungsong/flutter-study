import "package:flutter/material.dart";
import "package:random_dice/screen/home_screen.dart";
import "package:random_dice/screen/settings_screen.dart";
import "dart:math";
import "package:sensors_plus/sensors_plus.dart";

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;
  double threshold = 2.7;
  int number = 1;
  GyroscopeEvent? gyroscopeEvent;

  @override
  void initState() {
    super.initState();
    // 컨트롤러 초기화
    controller = TabController(length: 2, vsync: this);

    // 컨트롤러 속성이 변경될 때마다 실행함수 등록
    controller?.addListener(tabListener);
    gyroscopeEventStream(samplingPeriod: Duration(milliseconds: 100)).listen(
      (GyroscopeEvent event) {
        setState(() {
          gyroscopeEvent = event;
        });

        double x = double.parse(event.x.toStringAsFixed(1));
        double y = double.parse(event.y.toStringAsFixed(1));
        double z = double.parse(event.z.toStringAsFixed(1));

        if (x != 0.0 || y != 0.0 || z != 0.0) {
          onPhoneShake();
        }
      },
    );
  }

  void onPhoneShake() {
    final rand = Random();
    setState(() {
      number = rand.nextInt(5) + 1;
    });
  }

  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller!.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 탭 화면을 보여줄 위젯
      body: TabBarView(
        // 컨트롤러 등록
        controller: controller,
        children: renderChildren(),
      ),
      // 아래 탭 내비게이션 구현하는 매개변수
      bottomNavigationBar: renderBootomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(number: number, gyroscopeEvent: gyroscopeEvent),
      SettingScreen(threshold: threshold, onThresholdChange: onThresholdChange)
    ];
  }

  void onThresholdChange(double val) {
    setState(() {
      threshold = val;
    });
  }

  BottomNavigationBar renderBootomNavigation() {
    // 탭 내비게이션을 구현하는 위젯
    return BottomNavigationBar(
        currentIndex: controller!.index,
        onTap: (int index) {
          setState(() {
            controller!.animateTo(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.edgesensor_high_outlined,
              ),
              label: "주사위"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: "설정"),
        ]);
  }
}
