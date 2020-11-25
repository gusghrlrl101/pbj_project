import 'package:flutter/material.dart';
import 'package:pbj_project/my.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddClassPage extends StatefulWidget {
  @override
  _AddClassPageState createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final List<S2Choice<int>> days = [
    S2Choice<int>(title: '월', value: 1),
    S2Choice<int>(title: '화', value: 2),
    S2Choice<int>(title: '수', value: 3),
    S2Choice<int>(title: '목', value: 4),
    S2Choice<int>(title: '금', value: 5),
    S2Choice<int>(title: '토', value: 6),
    S2Choice<int>(title: '일', value: 7),
  ];
  final times = List.generate(
    9,
    (i) => S2Choice<int>(title: '${i + 1}', value: i + 1),
  );

  MyModel my;
  int selectedDay;
  TimeRange selectedTime;
  String time = '시간 선택';
  String title = '';
  String professor = '';

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
        title: Text('강의 등록'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Center(child: Text('요일')),
                      SmartSelect<int>.single(
                        title: '',
                        placeholder: '요일 선택',
                        value: selectedDay,
                        choiceItems: days,
                        onChange: (state) {
                          setState(() => selectedDay = state.value);
                        },
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Center(child: Text('시간')),
                      FlatButton(
                        onPressed: () async {
                          selectedTime = await showTimeRangePicker(
                            context: context,
                            interval: Duration(hours: 1),
                            start: TimeOfDay(hour: 9, minute: 0),
                            end: TimeOfDay(hour: 12, minute: 0),
                            disabledTime: TimeRange(
                              startTime: TimeOfDay(hour: 18, minute: 0),
                              endTime: TimeOfDay(hour: 9, minute: 0),
                            ),
                          );
                          setState(
                            () => time = selectedTime == null
                                ? '시간 선택'
                                : '${selectedTime.startTime.hour} ~ ${selectedTime.endTime.hour}',
                          );
                        },
                        color: Colors.blue,
                        child: Text(
                          time,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Center(child: Text('제목')),
                      TextField(
                        decoration: InputDecoration(hintText: '제목 입력'),
                        onChanged: (value) {
                          title = value;
                        },
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Center(child: Text('교수')),
                      TextField(
                        decoration: InputDecoration(hintText: '교수 입력'),
                        onChanged: (value) {
                          professor = value;
                        },
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          margin: EdgeInsets.all(10.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (selectedDay == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('요일을 선택하세요!'),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }

          if (selectedTime == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('시간을 선택하세요!'),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }

          if (title.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('제목을 입력하세요!'),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }

          if (professor.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('교수를 입력하세요!'),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }

          // TODO: save
          my.db.insert(
            'class',
            {
              'title': title,
              'professor': professor,
              'day': selectedDay,
              'startTime': selectedTime.startTime.hour,
              'endTime': selectedTime.endTime.hour,
            },
          );

          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  void refresh() {}
}
