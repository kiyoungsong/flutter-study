import 'package:random_dice/const/colors.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  final double threshold; // slider의 현재값
  final ValueChanged<double> onThresholdChange;

  const SettingScreen({
    required this.threshold,
    required this.onThresholdChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(children: [
            Text(
              "민감도",
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            ),
          ]),
        ),
        Slider(
          min: 0.1,
          max: 10.0,
          divisions: 101, // 최솟값과 최댓값 사이의 구간 개수
          value: threshold, // 슬라이더 선택값
          onChanged: onThresholdChange, // 값 변경 시 실행함수
          label: threshold.toStringAsFixed(1), // 소숫점 표시값
        )
      ],
    );
  }
}
