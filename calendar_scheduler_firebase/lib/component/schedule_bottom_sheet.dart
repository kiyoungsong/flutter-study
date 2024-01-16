import 'package:calendar_scheduler_firebase/component/custom_text_field.dart';
import 'package:calendar_scheduler_firebase/const/colors.dart';
import 'package:calendar_scheduler_firebase/model/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScheduleBottomSheet extends StatefulWidget {
  // 선택된 날짜 상위 위젯에서 입력받기
  final DateTime selectedDate;
  const ScheduleBottomSheet({required this.selectedDate, super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime; // 시작 시간 저장 변수
  int? endTime; // 종료 시간 저장 변수
  String? content; // 일정 내용 저장 변수

  @override
  Widget build(BuildContext context) {
    // 키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Form(
      key: formKey,
      child: SafeArea(
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
                Row(
                  children: [
                    Expanded(
                        child: CustomTextField(
                      label: "시작 시간",
                      isTime: true,
                      onSaved: (String? val) {
                        // 저장이 실행되면 startTime 변수에 텍스트 필드 값 저장
                        startTime = int.parse(val!);
                      },
                      validator: timeValidator,
                    )),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                        child: CustomTextField(
                      label: "종료 시간",
                      isTime: true,
                      onSaved: (String? val) {
                        // 저장이 실행되면 endTime 변수에 텍스트 필드 값 저장
                        endTime = int.parse(val!);
                      },
                      validator: timeValidator,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                    child: CustomTextField(
                  label: "내용",
                  isTime: false,
                  onSaved: (String? val) {
                    // 저장이 실행되면 content 변수에 텍스트 필드 값 저장
                    content = val;
                  },
                  validator: contentValidator,
                )),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSavePressed(context),
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
      ),
    );
  }

  void onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // 스케줄 모델 생성하기
      final schedule = ScheduleModel(
          id: Uuid().v4(),
          content: content!,
          date: widget.selectedDate,
          startTime: startTime!,
          endTime: endTime!);

      // 스케줄 모델 파이어스토어에 삽입하기
      await FirebaseFirestore.instance
          .collection('schedule')
          .doc(schedule.id)
          .set(schedule.toJson());

      // 일정 생성 후 화면 뒤로가기
      Navigator.of(context).pop();
    }
  }

  String? timeValidator(String? val) {
    if (val == null) {
      return "값을 입력해주세요.";
    }
    int? number;
    try {
      number = int.parse(val);
    } catch (e) {
      return "숫자를 입력해주세요.";
    }

    if (number < 0 || number > 24) {
      return "0시부터 24시 사이를 입력해주세요.";
    }
    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.length == 0) {
      return "값을 입력해주세요.";
    }
    return null;
  }
}
