import 'package:flutter/material.dart';

class TList extends StatelessWidget {
  List<Text> data = [
    Text('Text1'),
    Text('Text2'),
    Text('Text3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
        children: _buildList(),
      )),
    );
  }

  List<Widget> _buildList() {
    return data
        .map((Text e) => ListTile(
              title: e,
            ))
        .toList();
  }
}
