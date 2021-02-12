import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool delStatus = false;

  var map = const <int, String>{
    0: 'In Progress',
    1: 'Completed',
  };

  TList(this.data, {Key key, @required this.notifyParent}) : super(key: key);

  change_in_server(String step) async {
    String url = tasks.url + '/item/update';
    String body;
    int status;

    try {
      var response = await http.put(url,
          body: jsonEncode({'item': data, 'status': step}),
          headers: {'Content-Type': 'application/json'});

      status = response.statusCode;
      body = response.body;
    } catch (error) {
      status = 0;
      body = error.toString();
    }
    print('status code -- $status');
    print('Body -- $body');
    return status;
  }

  void change_list(int k) {
    if (k == 0) {
      if (change_in_server(map[k]) != 0)
        tasks.progress_list.add(new PList(data, notifyParent));
    } else {
      if (change_in_server(map[k]) != 0)
        tasks.complete_list.add(new CList(data, notifyParent));
    }
    delete();
  } // перемещение в другой лист

  del_from_serv(String task) async {
    String url = tasks.url + '/item/remove';
    String body;
    int status;
    try {
      var response = await http.post(url,
          body: jsonEncode({'item': task}),
          headers: {'Content-Type': 'application/json'});

      status = response.statusCode;
      body = response.body;
    } catch (error) {
      status = 0;
      body = error.toString();
    }
    print('status code -- $status');
    print('Body -- $body');
    return status;
  }

  void delete() {
    for (var i = 0; i < tasks.started_list.length; i++) {
      if (tasks.started_list[i].data == data) {
        print('Delete - ' + tasks.started_list[i].data);
        if (delStatus) {
          // если мы полностью удалаем задачу
          if (del_from_serv(data) != 0) {
            tasks.started_list.removeAt(i);
            notifyParent();
          }
        } else {
          // если перемещаем задачу
          tasks.started_list.removeAt(i);
          notifyParent();
        }
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
                          delStatus = true;
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
    0: 'Not Started',
    1: 'Completed',
  };

  PList(data, notifyParent) : super(data, notifyParent: notifyParent);

  @override
  void change_list(int k) {
    if (k == 0) {
      if (change_in_server(map[k]) != 0)
        tasks.started_list.add(new TList(data, notifyParent: notifyParent));
    } else {
      if (change_in_server(map[k]) != 0)
        tasks.complete_list.add(new TList(data, notifyParent: notifyParent));
    }
    delete();
  } // перемещение в другой лист

  @override
  void delete() {
    for (var i = 0; i < tasks.progress_list.length; i++) {
      if (tasks.progress_list[i].data == data) {
        print('Delete - ' + tasks.progress_list[i].data);
        if (delStatus) {
          if (del_from_serv(data) != 0) {
            tasks.progress_list.removeAt(i);
            notifyParent();
          }
        } else {
          tasks.progress_list.removeAt(i);
          notifyParent();
        }
      }
    }
  }
}

class CList extends TList {
  @override
  var map = const <int, String>{
    0: 'Not Started',
    1: 'In Progress',
  };

  CList(data, notifyParent) : super(data, notifyParent: notifyParent);

  @override
  void change_list(int k) {
    if (k == 0) {
      if (change_in_server(map[k]) != 0)
        tasks.started_list.add(new TList(data, notifyParent: notifyParent));
    } else {
      if (change_in_server(map[k]) != 0)
        tasks.progress_list.add(new PList(data, notifyParent));
    }
    delete();
  } // перемещение в другой лист

  @override
  void delete() {
    for (var i = 0; i < tasks.complete_list.length; i++) {
      if (tasks.complete_list[i].data == data) {
        print('Delete - ' + tasks.complete_list[i].data);
        if (delStatus) {
          if (del_from_serv(data) != 0) {
            tasks.complete_list.removeAt(i);
            notifyParent();
          }
        } else {
          tasks.complete_list.removeAt(i);
          notifyParent();
        }
      }
    }
  }
}
