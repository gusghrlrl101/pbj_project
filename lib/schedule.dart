import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pbj_project/add_schedule.dart';
import 'package:pbj_project/my.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final calendarController = CalendarController();
  final streamController = StreamController();
  MyModel my;
  List selectedEvents = [];
  final allEvents = Map<DateTime, List>();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () => refresh());
  }

  @override
  Widget build(BuildContext context) {
    my = Provider.of<MyModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('일정관리'),
      ),
      body: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: TableCalendar(
                      events: allEvents,
                      calendarController: calendarController,
                      onDaySelected: (day, events, holidays) {
                        setState(() => selectedEvents = events);
                      },
                      availableCalendarFormats: const {
                        CalendarFormat.month: ''
                      },
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      itemCount: selectedEvents.length,
                      itemBuilder: (context, i) => Card(
                        child: ListTile(
                          title: Text(selectedEvents[i]),
                        ),
                      ),
                      physics: ScrollPhysics(),
                    ),
                    height: 400,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final res = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddSchedulePage(),
            ),
          );

          if (res != null && res) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('등록 되었습니다!'),
                duration: Duration(seconds: 1),
              ),
            );
            refresh();
          }
        },
      ),
    );
  }

  void refresh() async {
    final res = await my.db.rawQuery('select * from schedule');

    allEvents.clear();
    for (final data in res) {
      final date = DateTime.parse(data['date']);
      if (!allEvents.containsKey(date)) allEvents[date] = [];
      allEvents[date].add(data['title']);
    }

    final today = DateTime.now();
    final curDate = DateTime(today.year, today.month, today.day);
    selectedEvents = allEvents[curDate] ?? [];

    streamController.add(true);
  }
}
