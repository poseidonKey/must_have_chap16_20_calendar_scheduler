import "package:flutter/material.dart";
import 'package:must_have_chap16_20_calendar_scheduler/component/main_calendar.dart';
import 'package:must_have_chap16_20_calendar_scheduler/component/schedule_card.dart';
import 'package:must_have_chap16_20_calendar_scheduler/component/today_banner.dart';
import '../component/schedule_bottom_sheet.dart';
import '../const/colors.dart';
import 'package:get_it/get_it.dart';
import '../database/drift_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(
              height: 8,
            ),
            TodayBanner(selectedDate: selectedDate, count: 0),
            Expanded(
              child: StreamBuilder<List<Schedule>>(
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // ➌ 데이터가 없을 때
                    return Container();
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final schedule = snapshot.data![index];
                      return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 8, right: 8),
                          child: ScheduleCard(
                              startTime: schedule.startTime,
                              endTime: schedule.endTime,
                              content: schedule.content),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                },
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              ),
            ),
            // const ScheduleCard(
            //     startTime: 12, endTime: 14, content: "Programming Study"),
            // const SizedBox(
            //   height: 8,
            // )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // ➊ 새 일정 버튼
          backgroundColor: PRIMARY_COLOR,
          onPressed: () {
            showModalBottomSheet(
              // ➋ BottomSheet 열기
              context: context,
              isDismissible: true, // ➌ 배경 탭했을 때 BottomSheet 닫기
              isScrollControlled: true, // 간단하게 최대 높이를 화면 전체로 변경
              builder: (_) => ScheduleBottomSheet(
                selectedDate: selectedDate,
              ),
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    // ➌ 날짜 선택될 때마다 실행할 함수
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
