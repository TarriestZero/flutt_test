import 'package:flutter/material.dart';

class Storages {
  List<String> started_list = ['s1', 's2'];
  List<TList> progress_list = [];
  List<String> complete_list = ['s1', 's2'];
}

Storages tasks = Storages();

class TList extends StatelessWidget {
  final String data;

  final Function() notifyParent;

  TList(this.data, {Key key, @required this.notifyParent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
            height: 100,
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                  child: ListView(children: [
                ListTile(
                  title: Text(data),
                ),
                Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          print('check');
                        },
                        child: Text(
                          'Not start',
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                    GestureDetector(
                        child: Text(
                      'Complete',
                      style: TextStyle(color: Colors.blueAccent),
                    )),
                    GestureDetector(
                        onTap: () {
                          for (var i = 0; i < tasks.progress_list.length; i++) {
                            if (tasks.progress_list[i].data == data) {
                              print('Delete - ' + tasks.progress_list[i].data);
                              tasks.progress_list.removeAt(i);
                              notifyParent();
                            }
                          }
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                )
              ])),
            )));
  }

  // List<Widget> _buildList(context) {
  //   return data.map((Text e) => ListTile(title: e..data
  //       //Theme.of(context).primaryColor,
  //       )).toList();
  // }

}
