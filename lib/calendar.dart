import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pbj_project/add_class.dart';
import 'package:pbj_project/memo.dart';
import 'package:pbj_project/my.dart';
import 'package:pbj_project/schedule.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class CalendarPage extends StatelessWidget {
  final streamController = StreamController();
  MyModel my;

  CalendarPage() {
    Future.delayed(Duration.zero, () => refresh());
  }

  @override
  Widget build(BuildContext context) {
    my = Provider.of<MyModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('시간표'),
      ),
      body: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final today = LocalDate.today();
          final basicEvents = (snapshot.data as List)
              .map(
                (data) => BasicEvent(
                  id: data['id'],
                  title: '${data['title']}\n(${data['professor']})',
                  color: Colors.blue,
                  start: today
                      .subtractDays(today.dayOfWeek.value - data['day'])
                      .at(LocalTime(data['startTime'], 0, 0)),
                  end: today
                      .subtractDays(today.dayOfWeek.value - data['day'])
                      .at(LocalTime(data['endTime'], 0, 0)),
                ),
              )
              .toList();
          final myEventProvider = EventProvider.list(basicEvents);
          final myController = TimetableController(
            eventProvider: myEventProvider,
            initialTimeRange: InitialTimeRange.range(
              startTime: LocalTime(8, 50, 0),
              endTime: LocalTime(18, 10, 0),
            ),
            visibleRange: VisibleRange.week(),
            firstDayOfWeek: DayOfWeek.monday,
          );

          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: AbsorbPointer(
                      child: Timetable<BasicEvent>(
                        controller: myController,
                        eventBuilder: (event) => BasicEventWidget(event),
                        allDayEventBuilder: (context, event, info) =>
                            BasicAllDayEventWidget(event, info: info),
                        leadingHeaderBuilder: (context, date) => Container(),
                        dateHeaderBuilder: (context, date) => Center(
                          child: Text(
                            date.dayOfWeek.toString().substring(0, 3),
                          ),
                        ),
                      ),
                    ),
                    height: 400,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text(
                      '강의등록',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddClassPage(),
                        ),
                      );

                      if (res != null && res) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('강의가 등록 되었습니다!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        refresh();
                      }
                    },
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text(
                      '일정관리',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SchedulePage(),
                      ),
                    ),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text(
                      '메모',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MemoPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.all(10.0),
          );
        },
      ),
    );
  }

  void refresh() async {
    final res = await my.db.rawQuery('select * from class');
    print(res);
    streamController.add(res);
  }
}
