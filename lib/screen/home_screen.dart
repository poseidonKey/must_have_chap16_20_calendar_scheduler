import "package:flutter/material.dart";
import 'package:must_have_chap16_20_calendar_scheduler/component/main_calendar.dart';
import 'package:must_have_chap16_20_calendar_scheduler/component/schedule_card.dart';
import 'package:must_have_chap16_20_calendar_scheduler/component/today_banner.dart';
import 'package:table_calendar/table_calendar.dart';

import '../component/schedule_bottom_sheet.dart';
import '../const/colors.dart';

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
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
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
            const ScheduleCard(
                startTime: 12, endTime: 14, content: "Programming Study"),
            const SizedBox(
              height: 8,
            )
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
              builder: (_) => const ScheduleBottomSheet(),
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
