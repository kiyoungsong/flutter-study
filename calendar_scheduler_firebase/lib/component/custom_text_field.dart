import 'package:calendar_scheduler_firebase/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextField(
      {required this.label,
      required this.isTime,
      required this.onSaved,
      required this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: isTime ? 0 : 1,
          child: TextFormField(
            // 폼 저장 시 실행 함수
            onSaved: onSaved,
            // 폼 검증 시 실행 함수
            validator: validator,
            cursorColor: Colors.grey,
            // 시간 관련 텍스트 필드가 아니면 한 줄 이상 작성 가능
            maxLines: isTime ? 1 : null,
            expands: !isTime,
            // 시간 관련 텍스트 필드는 기본 숫자 키보드 아니면 일반 글자 키보드 보여주기
            keyboardType:
                isTime ? TextInputType.number : TextInputType.multiline,
            // 시간 관련 텍스트 필드는 숫자만 입력하도록 제한
            inputFormatters: isTime
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : [],
            decoration: InputDecoration(
                // 테두리 삭제
                border: InputBorder.none,
                // 배경색 지정
                filled: true,
                // 배경색
                fillColor: Colors.grey[300],
                // 접미사 추가
                suffixText: isTime ? "시" : null),
          ),
        ),
      ],
    );
  }
}
