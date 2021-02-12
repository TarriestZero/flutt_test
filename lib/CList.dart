import 'package:flutter/material.dart';

class Storages {
  List<TList> started_list = [];
  List<TList> progress_list = [];
  List<TList> complete_list = [];
  String url = 'http://65.21.6.142:8822';
}

Storages tasks = Storages();

class TList extends StatelessWidget {
  final String data;
  final Function() notifyParent;

  var map = const <int, String>{
    0: 'In progress',
    1: 'Complete',
  };

  TList(this.data, {Key key, @required this.notifyParent}) : super(key: key);

  void change_list(int k) {
    if (k == 0) {
      tasks.progress_list.add(new PList(data, notifyParent));
    } else {
      tasks.complete_list.add(new CList(data, notifyParent));
    }
    delete();
  } // перемещение в другой лист

  void delete() {
    for (var i = 0; i < tasks.started_list.length; i++) {
      if (tasks.started_list[i].data == data) {
        print('Delete - ' + tasks.started_list[i].data);
        tasks.started_list.removeAt(i);
        notifyParent();
      }
    }
  }

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
                          change_list(0);
                          notifyParent();
                        },
                        child: Text(
                          map[0],
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                    GestureDetector(
                        onTap: () {
                          change_list(1);
                          notifyParent();
                        },
                        child: Text(
                          map[1],
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                    GestureDetector(
                        onTap: () {
                          delete();
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
}

class PList extends TList {
  @override
  var map = const <int, String>{
    0: 'Not started',
    1: 'Complete',
  };

  PList(data, notifyParent) : super(data, notifyParent: notifyParent);

  @override
  void change_list(int k) {
    if (k == 0) {
      tasks.started_list.add(new TList(data, notifyParent: notifyParent));
    } else {
      tasks.complete_list.add(new TList(data, notifyParent: notifyParent));
    }
    delete();
  } // перемещение в другой лист

  @override
  void delete() {
    for (var i = 0; i < tasks.progress_list.length; i++) {
      if (tasks.progress_list[i].data == data) {
        print('Delete - ' + tasks.progress_list[i].data);
        tasks.progress_list.removeAt(i);
        notifyParent();
      }
    }
  }
}

class CList extends TList {
  @override
  var map = const <int, String>{
    0: 'Not started',
    1: 'In progress',
  };

  CList(data, notifyParent) : super(data, notifyParent: notifyParent);

  @override
  void change_list(int k) {
    if (k == 0) {
      tasks.started_list.add(new TList(data, notifyParent: notifyParent));
    } else {
      tasks.progress_list.add(new PList(data, notifyParent));
    }
    delete();
  } // перемещение в другой лист

  @override
  void delete() {
    for (var i = 0; i < tasks.complete_list.length; i++) {
      if (tasks.complete_list[i].data == data) {
        print('Delete - ' + tasks.complete_list[i].data);
        tasks.complete_list.removeAt(i);
        notifyParent();
      }
    }
  }
}
