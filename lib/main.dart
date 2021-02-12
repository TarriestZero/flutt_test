import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      home: HomePage(
        url: 'http://65.21.6.142:8822',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String url;

  HomePage({String url}) : url = url;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _url, _body;
  int _status;

  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    _url = widget.url;
    _getTasks();
    super.initState();
    print(_url);
  }

  _sendRequestPostBodyHeaders(String task) async {
    // if (_formKey.currentState.validate()) {
    String url = _url + '/item/new';
    // _formKey.currentState.save(); //запуск функции
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
    // }
  }

  _getTasks() async {
    String url = _url + '/items/all';
    http.get(url).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      Map<String, dynamic> map = jsonDecode(response.body);
      int count = map['count'];
      print('Decode count -- $count');
      for (var item in map['items']) {
        if (item[1] == 'Not Started') {
          print(item[0]);
          tasks.started_list.add(new TList(item[0], notifyParent: refresh));
        }
        if (item[1] == 'In Progress') {
          print(item[0]);
          tasks.progress_list.add(new PList(item[0], refresh));
        }
        if (item[1] == 'Completed') {
          print(item[0]);
          tasks.complete_list.add(new CList(item[0], refresh));
        }
      }
      setState(() {});
    }).catchError((error) {
      print("Error: $error");
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Ошибка подлкючения $error'),
        backgroundColor: Colors.red,
      ));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('TODO list'),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
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
              Column(
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
              Column(
                children: [
                  if (tasks.progress_list.length > 0) ...tasks.progress_list,
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
              Column(
                children: [
                  if (tasks.complete_list.length > 0) ...tasks.complete_list,
                  if (tasks.complete_list.length == 0)
                    Container(
                        margin: EdgeInsets.only(top: 150),
                        child: Text(
                          'No one complete',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ))
                ],
              )
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
              });
            },
          )),
    );
  }
}
