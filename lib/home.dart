import 'package:flutter/material.dart';
import 'package:pbj_project/calendar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('학업 계획 어플'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('2014440053\n박병재'),
            FlatButton(
              color: Colors.blue,
              child: Text(
                '시작',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final res = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(),
                  ),
                );

                if (res != null && res) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('등록 되었습니다!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }
}
