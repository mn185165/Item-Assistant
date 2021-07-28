import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'help.dart';
import 'item.dart';

class HelpPageModel {
  final DatabaseService database = new DatabaseService();
  final Help help;
  Item? item;
  Stream<DocumentSnapshot>? helpStream;

  HelpPageModel(this.help) {
    this.database.getItem(this.help.plu).then((value) => this.item = value);
  }
}
