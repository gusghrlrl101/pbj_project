import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pbj_project/add_memo.dart';
import 'package:pbj_project/my.dart';
import 'package:provider/provider.dart';

class MemoPage extends StatelessWidget {
  final streamController = StreamController();
  MyModel my;

  MemoPage() {
    Future.delayed(Duration.zero, () => refresh());
  }

  @override
  Widget build(BuildContext context) {
    my = Provider.of<MyModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('메모'),
      ),
      body: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final data = snapshot.data as List;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) => Card(
              child: ListTile(
                title: Text(data[i]['title']),
                onTap: () async {
                  final res = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddMemoPage(
                        isEdit: true,
                        id: data[i]['id'],
                      ),
                    ),
                  );

                  if (res != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text((res ? '수정' : '삭제') + ' 되었습니다!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    refresh();
                  }
                },
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
              builder: (context) => AddMemoPage(),
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
    final res = await my.db.rawQuery('select * from memo');
    print(res);
    streamController.add(res);
  }
}
