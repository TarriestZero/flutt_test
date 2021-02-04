import 'package:flutter/material.dart';
import 'addMenu.dart';


class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondRoute()),
        );
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
