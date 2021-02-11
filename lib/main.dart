import 'package:flutter/material.dart';

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
  refresh() {
    setState(() {});
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
                      setState(() {});
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
