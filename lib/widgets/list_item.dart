import 'package:flutter/material.dart';

/// Basic Text styling for small titles

class ListItem extends StatefulWidget {
  String? text;
  bool? checked;

  ListItem({Key? key, required this.text, required this.checked})
      : super(key: key);

  @override
  ListItemState createState() => ListItemState();
}

class ListItemState extends State<ListItem> {
  String? text;
  bool? checked;

  @override
  void initState() {
    setState(() {
      text = this.widget.text;
      checked = this.widget.checked;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
        child: Row(
          children: [
            Transform.scale(
              scale: 2.0,
              child: new Checkbox(
                value: this.checked,
                onChanged: (val) => {
                  setState(() {
                    checked = val;
                  })
                },
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 8),
                width: 230,
                child: Text(
                  this.text.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                )),
            Container(
                margin: EdgeInsets.all(10),
                child: Align(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: Size(35, 35),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    child: Text('X'),
                    onPressed: () => () {},
                  ),
                  alignment: Alignment.topRight,
                ))
          ],
        ));
  }
}

/*

*/
