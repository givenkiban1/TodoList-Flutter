import 'dart:convert';
import 'package:todo_list/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/screens/add_list.dart';
import 'package:todo_list/screens/list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MyHomePage(title: 'TODO List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoListItem>? list = [];

  @override
  void initState() {
    _fetchLists();
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

  void _fetchLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //await prefs.setStringList('Lists', []);

    List<String>? res = prefs.getStringList('Lists');

    if (res != null) if (res.isNotEmpty) {
      List<ToDoListItem> listItems = [];

      for (var entry in res) {
        Map<String, dynamic> item = jsonDecode(entry);
        ToDoListItem x;
        if (item != null) {
          x = ToDoListItem.fromJson(item);
          listItems.add(x);
        }
      }

      setState(() {
        list = listItems;
      });
    }
  }

  void _removeList(ToDoListItem item) async {
    list!.remove(item);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listItems = [];

    for (var entry in list!) listItems.add(jsonEncode(entry));

    prefs.setStringList('Lists', listItems);

    _fetchLists();

    _showAlert(item.title + " list removed.");
  }

  void _getToList(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('SelectedList', title);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListViewApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            if (list != null)
              //list!.isNotEmpty
              for (var entry in list!)
                Container(
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: colors[entry.color],
                        minimumSize: Size(350, 70),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      child: Text(entry.title),
                      onPressed: () => _getToList(entry.title),
                      onLongPress: () => _removeList(entry),
                    ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListPage()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/*
  void _showAlert(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return new Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
        );
      },
    );
  }

  */
