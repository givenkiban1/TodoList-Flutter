import 'dart:convert';
import 'package:todo_list/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/widgets/list_item.dart';

class ListViewApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListViewPage(title: 'Add List'),
    );
  }
}

class ListViewPage extends StatefulWidget {
  ListViewPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ListViewPageState createState() => ListViewPageState();
}

class ListViewPageState extends State<ListViewPage> {
  String? selectedColorName = "";
  String? titleName = "";
  List<String>? listItems = [];
  ToDoListItem? selected;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _fetchListData();
    super.initState();
  }

  final Map<String, Color> colors = {
    'purple': Colors.purple,
    'blue': Colors.blue,
    'yellow': Colors.yellow,
    'pink': Colors.pink,
    'teal': Colors.teal,
    'orange': Colors.orange,
  };

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

  void _fetchListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? res = prefs.getStringList('Lists');
    String? selectedListItem = prefs.getString('SelectedList');

    if (res!.isNotEmpty && selectedListItem!.isNotEmpty) {
      for (var entry in res) {
        Map<String, dynamic> item = jsonDecode(entry);
        ToDoListItem x;
        if (item != null) {
          x = ToDoListItem.fromJson(item);
          if (x.title == selectedListItem) {
            List<String> items = [];
            for (var i in x.items) items.add(i);
            setState(() {
              selectedColorName = x.color;
              titleName = x.title;
              listItems = items;

              selected = x;
            });
            break;
          }
        }
      }
    } else {
      _showAlert("All to-do lists have been cleared!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  void _addToList() async {
    selected!.addListItem(myController.text);
    setState(() {
      selected = selected;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? res = prefs.getStringList('Lists');
    String? selectedListItem = prefs.getString('SelectedList');

    if (res!.isNotEmpty && selectedListItem!.isNotEmpty) {
      for (var o = 0; o < res.length; o++) {
        var entry = res[o];
        Map<String, dynamic> item = jsonDecode(entry);
        ToDoListItem x;
        if (item != null) {
          x = ToDoListItem.fromJson(item);
          if (x.title == selected!.title) {
            res[o] = jsonEncode(selected);

            prefs.setStringList('Lists', res);
            break;
          }
        }
      }
      myController.clear();
      _fetchListData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(selected!.title.toString()),
        backgroundColor: colors[selected?.color],
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(padding: const EdgeInsets.all(1), children: <Widget>[
        for (var entry in selected!.items)
          ListItem(checked: false, text: entry),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 240,
                  child: TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'List Item',
                    ),
                    controller: myController,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      minimumSize: Size(40, 30),
                      textStyle: TextStyle(fontSize: 15),
                    ),
                    child: Text('Add'),
                    onPressed: () => _addToList(),
                  ),
                )
              ],
            )),
      ])),
    );
  }
}
