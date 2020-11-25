import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pbj_project/my.dart';
import 'package:provider/provider.dart';

class AddMemoPage extends StatefulWidget {
  final bool isEdit;
  final int id;

  AddMemoPage({this.isEdit = false, this.id});

  @override
  _AddMemoPageState createState() => _AddMemoPageState();
}

class _AddMemoPageState extends State<AddMemoPage> {
  final streamController = StreamController();
  MyModel my;
  String title = '';
  String content = '';
  TextEditingController titleController;
  TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      if (widget.isEdit) {
        final res = await my.db.rawQuery(
          'select title, content from memo where id = ${widget.id}',
        );

        if (res.length == 1) {
          title = res[0]['title'];
          content = res[0]['content'];
        }
      }

      titleController = TextEditingController(text: title);
      contentController = TextEditingController(text: content);

      streamController.add(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    my = Provider.of<MyModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('메모 ' + (widget.isEdit ? '수정' : '추가')),
      ),
      body: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Center(
            child: Container(
              child: Column(
                children: [
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Text('제목'),
                          TextField(
                            controller: titleController,
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('내용'),
                          TextField(
                            controller: contentController,
                            onChanged: (value) {
                              content = value;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (widget.isEdit)
                    FlatButton(
                      color: Colors.red,
                      child: Text(
                        '삭제',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await my.db.delete('memo', where: 'id = ${widget.id}');

                        Navigator.of(context).pop(false);
                      },
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              margin: EdgeInsets.all(10.0),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          if (title.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('제목을 입력하세요!'),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }

          if (content.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('내용을 입력하세요!'),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }

          if (widget.isEdit) {
            await my.db.update('memo', {'title': title, 'content': content},
                where: 'id = ${widget.id}');
          } else {
            await my.db.insert('memo', {'title': title, 'content': content});
          }

          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}
