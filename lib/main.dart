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
                  ...tasks.started_list,
                ],
              ),
              Column(
                children: [
                  ...tasks.progress_list,
                ],
              ),
              Column(
                children: [
                  ...tasks.complete_list,
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
