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
              ListView(
                children: [
                  for (var item in tasks.started_list)
                    ListTile(
                      title: Text(item),
                    ),
                  Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('some tex1'),
                      Text('Some text2'),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  ...tasks.progress_list,
                ],
              ),

              // ListView.builder(
              //     itemCount: 1,
              //     itemBuilder: (context, i) {
              //       return Card(
              //         child: Container(child: progress_list[0]),
              //       );
              //     })),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.black12,
                    child: Text('Checkkkk'),
                  )
                ],
              )
            ],
          ),
          floatingActionButton: AddButton(
            callback: (e) {
              setState(() {
                tasks.progress_list.add(new TList(
                  e,
                  notifyParent: refresh,
                ));
              });
            },
          )),
    );
  }
}
