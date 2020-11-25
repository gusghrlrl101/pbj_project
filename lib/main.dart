import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbj_project/home.dart';
import 'package:pbj_project/my.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final my = MyModel();

    return Provider<MyModel>(
      create: (context) => my,
      child: MaterialApp(
        title: '박병재 프로젝트',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
