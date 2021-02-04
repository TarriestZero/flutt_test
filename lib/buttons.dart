import 'package:flutter/material.dart';

import 'addMenu.dart';

class AddButton extends StatelessWidget {
  final callback;

  const AddButton({Key key, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        var a = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondRoute()),
        );
        if (a != null) callback(a);
      },
      child: Icon(Icons.add_circle),
      backgroundColor: Colors.blue,
    );
  }
}

class RefButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child: null, onRefresh: null);
  }
}
