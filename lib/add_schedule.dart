import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pbj_project/my.dart';
import 'package:provider/provider.dart';

class AddSchedulePage extends StatefulWidget {
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  MyModel my;
  String title = '';
  DateTime selectedDate;
  String date = '날짜 입력';

  @override
  Widget build(BuildContext context) {
    my = Provider.of<MyModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('일정 추가'),
      ),
      body: Center(
        child: Container(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Center(child: Text('날짜')),
                  FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 1, 1),
                        maxTime: DateTime(2024, 12, 31),
                        onConfirm: (date) {
                          selectedDate = date;
                          setState(
                            () => this.date =
                                '${date.year}-${date.month}-${date.day}',
                          );
                        },
                        currentTime: selectedDate ?? DateTime.now(),
                        locale: LocaleType.ko,
                      );
                    },
                    color: Colors.blue,
                    child: Text(
                      this.date,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
            ],
          ),
          margin: EdgeInsets.all(10.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (selectedDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('날짜를 선택하세요!'),
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

          my.db.insert(
            'schedule',
            {
              'title': title,
              'date':
                  '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
            },
          );

          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}
