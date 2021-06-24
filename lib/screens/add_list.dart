import 'dart:convert';
import 'package:todo_list/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/main.dart';

class ListPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do List',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: AddListPage(title: 'Add List'),
    );
  }
}

class AddListPage extends StatefulWidget {
  AddListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  AddListPageState createState() => AddListPageState();
}

class AddListPageState extends State<AddListPage> {
  final Map<String, Color> colors1 = {
    'purple': Colors.purple,
    'blue': Colors.blue,
    'yellow': Colors.yellow,
  };

  final Map<String, Color> colors2 = {
    'pink': Colors.pink,
    'teal': Colors.teal,
    'orange': Colors.orange,
  };

  Color? selectedColor = Colors.blue;
  String? selectedColorName = "blue";
  String? titleName = "";
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _setColor(String colorName, Color color) async {
    setState(() {
      selectedColor = color;
      selectedColorName = colorName;
    });
  }

  void _showAlert(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the user has entered by using the
          // TextEditingController.
          content: Text(text),
        );
      },
    );
  }

  void _addToList() async {
    if (myController.text == "") {
      _showAlert('You need to enter a title for this list.');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? res = prefs.getStringList('Lists');

      Map<String, dynamic> item;

      if (res != null) if (res.isNotEmpty) {
      } else {
        res = [];
      }
      else {
        res = [];
      }

      ToDoListItem list = ToDoListItem.fromJson({
        "title": myController.text,
        "color": selectedColorName,
        "items": [],
      });

      res.add(jsonEncode(list));

      prefs.setStringList('Lists', res);

      _showAlert('New List Added!');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          padding: const EdgeInsets.all(1),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'List Title',
                ),
                controller: myController,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var entry in colors1.entries)
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: entry.value, minimumSize: Size(80, 80)),
                        child: Text(''),
                        onPressed: () => _setColor(entry.key, entry.value),
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var entry in colors2.entries)
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: entry.value, minimumSize: Size(80, 80)),
                        child: Text(''),
                        onPressed: () => _setColor(entry.key, entry.value),
                      ),
                    )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      minimumSize: Size(350, 60),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    child: Text('Add List'),
                    onPressed: () => _addToList(),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
