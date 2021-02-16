import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'CList.dart';
import 'buttons.dart';

void main() => runApp(TabsApp());

class TabsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _url, _body;
  int _status;
  bool _saving = false;

  refresh() {
    setState(() {});
  }

  bool check_exist(List<TList> listtask, String task) {
    for (var item in listtask) {
      if (item.data == task) return false;
    }
    return true;
  }

  @override
  void initState() {
    _url = tasks.url;
    _getTasks();
    super.initState();
    print(_url);
  }

  _sendRequestPostBodyHeaders(String task) async {
    String url = _url + '/item/new';
    tasks.saving = true;
    try {
      var response = await http.post(url,
          body: jsonEncode({'item': task}),
          headers: {'Content-Type': 'application/json'});

      _status = response.statusCode;
      _body = response.body;
    } catch (error) {
      _status = 0;
      _body = error.toString();
    }
    print('status code -- $_status');
    print('Body -- $_body');

    return _status;
  }

  _getTasks() async {
    String url = _url + '/items/all';
    tasks.saving = true;
    http.get(url).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      Map<String, dynamic> map = jsonDecode(response.body);
      int count = map['count'];
      print('Decode count -- $count');
      for (var item in map['items']) {
        if (item[1] == 'Not Started') {
          print(item[0]);
          if (check_exist(tasks.started_list, item[0]))
            tasks.started_list.add(new TList(item[0], notifyParent: refresh));
        }
        if (item[1] == 'In Progress') {
          print(item[0]);
          if (check_exist(tasks.progress_list, item[0]))
            tasks.progress_list.add(new PList(item[0], refresh));
        }
        if (item[1] == 'Completed') {
          print(item[0]);
          if (check_exist(tasks.complete_list, item[0]))
            tasks.complete_list.add(new CList(item[0], refresh));
        }
      }
      tasks.saving = false;
      setState(() {});
    }).catchError((error) {
      print("Error: $error");
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Ошибка подлкючения $error'),
        backgroundColor: Colors.red,
      ));
      tasks.saving = false;
      setState(() {});
    });
  }


// user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(""),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: ModalProgressHUD(
          inAsyncCall: tasks.saving,
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('TODO list'),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          tasks.progress_list.clear();
                          tasks.started_list.clear();
                          tasks.complete_list.clear();
                          print('refresh');
                          _getTasks();
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 26.0,
                        ),
                      )),
                ],
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: 'Not started',
                    ),
                    Tab(
                      text: 'In progress',
                    ),
                    Tab(
                      text: 'Completed',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ListView(
                    children: [
                      if (tasks.started_list.length > 0) ...tasks.started_list,
                      if (tasks.started_list.length == 0)
                        Container(
                            margin: EdgeInsets.only(top: 150),
                            child: Text(
                              'Items not found \n Tap "+" to create new one',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25),
                            ))
                    ],
                  ),
                  ListView(
                    children: [
                      if (tasks.progress_list.length > 0)
                        ...tasks.progress_list,
                      if (tasks.progress_list.length == 0)
                        Container(
                            margin: EdgeInsets.only(top: 150),
                            child: Text(
                              'No one in progress',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25),
                            ))
                    ],
                  ),
                  ListView(
                    children: [
                      if (tasks.complete_list.length > 0)
                        ...tasks.complete_list,
                      if (tasks.complete_list.length == 0)
                        Container(
                            margin: EdgeInsets.only(top: 150),
                            child: Text(
                              'No one complete',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25),
                            ))
                    ],
                  ),
                ],
              ),
              floatingActionButton: AddButton(
                callback: (e) {
                  setState(() {
                    if (_sendRequestPostBodyHeaders(e) != 0)
                      tasks.started_list.add(new TList(
                        e,
                        notifyParent: refresh,
                      ));
                    tasks.saving = false;
                  });
                },
              ))),
    );
  }
}
