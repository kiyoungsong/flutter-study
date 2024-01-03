import 'package:calendar_scheduler/component/custom_test_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    // 키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Container(
        // 화면의 반을 차지
        height: MediaQuery.of(context).size.height / 2 + bottomInset,
        color: Colors.white,
        child: Padding(
          padding:
              // 패딩에 키보드 높이를 추가해서 위젯 전반적으로 위로 올려주기
              EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
          child: Column(
            children: [
              const Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                    label: "시작 시간",
                    isTime: true,
                  )),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                      child: CustomTextField(
                    label: "종료 시간",
                    isTime: true,
                  )),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Expanded(
                  child: CustomTextField(label: "내용", isTime: false)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1)),
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: const Text(
                    "저장",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onSavePressed() {}
}
