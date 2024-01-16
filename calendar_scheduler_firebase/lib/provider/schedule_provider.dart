import 'package:calendar_scheduler_firebase/model/schedule_model.dart';
import 'package:calendar_scheduler_firebase/repository/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  // api요청 로직을 담은 클래스
  final ScheduleRepository repository;

  // 성택한 날짜
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // 일정 정보를 저장해둘 변수
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({required this.repository}) : super() {
    getSchedules(date: selectedDate);
  }

  void getSchedules({required DateTime date}) async {
    final resp = await repository.getSchedules(date: date);
    // 캐시 날짜 업데이트
    cache.update(date, (value) => resp, ifAbsent: () => resp);
    // 리슨하는 위젯들 업데이트
    notifyListeners();
  }

  void createSchedules({required ScheduleModel schedule}) async {
    final targetDate = schedule.date;
    // 긍정적 응답 추가
    final uuid = Uuid();
    final tempId = uuid.v4();
    final newSchedule = schedule.copyWith(id: tempId);
    // 긍정적 응답 구간
    cache.update(
        targetDate,
        (value) => [
              ...value,
              newSchedule,
            ]..sort(
                (a, b) => a.startTime.compareTo(
                  b.startTime,
                ),
              ),
        ifAbsent: () => [newSchedule]);
    notifyListeners();

    try {
      final savedSchedule = await repository.createSchedule(schedule: schedule);
      // 서버 응답 기반으로 캐시 업데이트
      cache.update(
          targetDate,
          (value) => value
              .map((e) => e.id == tempId ? e.copyWith(id: savedSchedule) : e)
              .toList());
    } catch (e) {
      // 실패시 캐시 롤백
      cache.update(
          targetDate, (value) => value.where((e) => e.id != tempId).toList());
    }

    notifyListeners();
  }

  void deleteSchedules({required DateTime date, required String id}) async {
    // 삭제할 일정 기억
    final targetSchedule = cache[date]!.firstWhere((e) => e.id == id);

    // 긍정적 응답 (응답 전 캐시 삭제)
    cache.update(date, (value) => value.where((e) => e.id != id).toList(),
        ifAbsent: () => []);

    notifyListeners();

    try {
      // 삭제 함수 실행
      await repository.deleteSchedule(id: id);
    } catch (e) {
      cache.update(
          date,
          (value) => [...value, targetSchedule]
            ..sort((a, b) => a.startTime.compareTo(b.startTime)));
    }

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );
    notifyListeners();
  }

  void changeSelectedDate({
    required DateTime date,
  }) async {
    selectedDate = date;
    notifyListeners();
  }
}
