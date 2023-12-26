import 'package:flutter/material.dart';

class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform;
  final String imgPath;
  final bool isSelected;

  const EmoticonSticker(
      {required this.onTransform,
      required this.imgPath,
      required this.isSelected,
      super.key});
  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  double scale = 1; // 확대/축소 배율
  double hTransform = 0; // 가로의 움직임
  double vTransform = 0; // 세로의 움직임
  double actualScale = 1; // 위젯의 초기 크기 기준 확대/축소 배율

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(hTransform, vTransform)
        ..scale(scale, scale),
      child: Container(
          decoration: widget.isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.0,
                  ))
              : BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.transparent)),
          child: GestureDetector(
              // 스티커를 눌렀을 때 실행할 함수
              onTap: () {
                // 스티커의 상태가 변경될 때마다 실행
                widget.onTransform();
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                // 스키터의 확대 비율이 변경됐을 때 실행
                widget.onTransform();
                setState(() {
                  scale = details.scale * actualScale;
                  // 최근 확대 비율 기반으로 실제 확대 비율 계산
                  // 세로 이동 거리 계산
                  vTransform += details.focalPointDelta.dy;
                  // 가로 이동 거리 계산
                  hTransform += details.focalPointDelta.dx;
                });
              },
              onScaleEnd: (ScaleEndDetails details) {
                actualScale = scale;
              },
              child: Image.asset(widget.imgPath))),
    );
  }
}
