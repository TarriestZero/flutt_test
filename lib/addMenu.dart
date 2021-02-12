import 'package:flutter/material.dart';
import 'package:flutter_check/CList.dart';

class MyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  bool _checkRepeat(String text) {
    for (var item in tasks.started_list) {
      if (item.data == text) return false;
    }
    for (var item in tasks.progress_list) {
      if (item.data == text) return false;
    }
    for (var item in tasks.complete_list) {
      if (item.data == text) return false;
    }
    return true;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: new Form(
            key: _formKey,
            child: new Column(
              children: <Widget>[
                new Text(
                  'Задача:',
                  style: TextStyle(fontSize: 20.0),
                ),
                new TextFormField(
                    controller: myController,
                    validator: (value) {
                      if (value.isEmpty) return 'Пожалуйста введите задачу';
                    }),
                new SizedBox(height: 20.0),
                new RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (_checkRepeat(myController.text)) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Форма успешно заполнена'),
                          backgroundColor: Colors.green,
                        ));
                        print(myController.text); // запись в list
                        Navigator.pop(context, myController.text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Такая задача существует'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  },
                  child: Text('Проверить'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            )));
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Add task"),
        ),
        body: new MyForm());
  }
}
