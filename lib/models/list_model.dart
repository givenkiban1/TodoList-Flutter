import 'package:flutter/material.dart';

class ToDoListItem {
  String title = "";
  String color = "";
  List<dynamic> items = [];

  ToDoListItem({required this.title, required this.color, required this.items});

  ToDoListItem.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.color = json['color'];
    this.items = json['items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['color'] = this.color;
    data['items'] = this.items;
    return data;
  }

  void addListItem(String item) {
    items.add(item);
  }

  bool removeListItem(String item) {
    return items.remove(item);
  }

  @override
  String toString() {
    return '"info" : { "title": $title, "color": $color, "items": $items}';
  }
}
