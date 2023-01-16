import 'package:flutter/material.dart';
import 'package:must_have_chap16_20_calendar_scheduler/provider/schedule_provider.dart';
import '../component/main_calendar.dart';
import '../component/schedule_card.dart';
import '../component/today_banner.dart';
import '../component/schedule_bottom_sheet.dart';
import '../const/colors.dart';
import 'package:get_it/get_it.dart';
import '../database/drift_database.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  DateTime selectedDate = DateTime.utc(
    // ➋ 선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // ➊ 새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            // ➋ BottomSheet 열기
            context: context,
            isDismissible: true, // ➌ 배경 탭했을 때 BottomSheet 닫기
            isScrollControlled: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate, // 선택된 날짜 (selectedDate) 넘겨주기
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        // 시스템 UI 피해서 UI 구현하기
        child: Column(
          // 달력과 리스트를 세로로 배치
          children: [
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달하기

              // 날짜가 선택됐을 때 실행할 함수
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            const SizedBox(height: 8.0),
            TodayBanner(
              selectedDate: selectedDate,
              count: schedules.length,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                // ➍ 화면에 보이는 값들만 렌더링하는 리스트
                itemCount: schedules.length, // ➎ 리스트에 입력할 값들의 총 개수
                itemBuilder: (context, index) {
                  final schedule = schedules[index]; // ➏ 현재 index에 해당되는 일정
                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    // ➊ 유니크한 키값
                    direction: DismissDirection.startToEnd,
                    // ➋ 밀기 방향 (오른쪽에서 왼쪽으로)
                    onDismissed: (DismissDirection direction) {
                      // ➌ 밀기 했을 때 실행할 함수
                      provider.deleteSchedule(
                          date: selectedDate, id: schedule.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 8.0, right: 8.0),
                      child: ScheduleCard(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
      DateTime selectedDate, DateTime focusedDate, BuildContext context) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  }
}
