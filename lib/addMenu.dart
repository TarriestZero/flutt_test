import 'package:flutter/material.dart';
import 'CList.dart';

class MyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

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
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Форма успешно заполнена'),
                        backgroundColor: Colors.green,
                      ));
                      print(myController.text); // запись в list

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
