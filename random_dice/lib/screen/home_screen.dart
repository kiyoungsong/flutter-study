import "package:flutter/material.dart";
import "package:random_dice/const/colors.dart";
import "package:sensors_plus/sensors_plus.dart";

class HomeScreen extends StatelessWidget {
  final int number;
  final GyroscopeEvent? gyroscopeEvent;
  const HomeScreen({
    required this.number,
    required this.gyroscopeEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('asset/img/$number.png'),
      const SizedBox(
        height: 32.0,
      ),
      Text(
        "행운의 숫자",
        style: TextStyle(
            color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w700),
      ),
      const SizedBox(
        height: 12.0,
      ),
      Text(
        number.toString(),
        style: const TextStyle(
            color: primaryColor, fontSize: 60.0, fontWeight: FontWeight.w200),
      ),
      Text(
        "x:(${gyroscopeEvent?.x.toString()})" ?? '?',
        style: TextStyle(
            color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w700),
      ),
      Text(
        "y:(${gyroscopeEvent?.y.toString()})" ?? '?',
        style: TextStyle(
            color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w700),
      ),
      Text(
        "z:(${gyroscopeEvent?.y.toString()})" ?? '?',
        style: TextStyle(
            color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w700),
      )
    ]);
  }
}
