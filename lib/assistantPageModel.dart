import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'help.dart';
import 'helpPage.dart';
import 'item.dart';

class AssistantPageModel {
  final DatabaseService database = new DatabaseService();
  String assistantName = "";
  String inputText = "Please enter your name: ";
  bool gotAssistantName = false;
  bool isLoading = false;
  bool showHelpButton = true;
  int indexExpanded = -1;
  Map<String, Help> mapHelps = {};
  Stream<QuerySnapshot>? helpStream;
  Item? item;
  String helpButtonText = "Help this customer";

  void updateHelpButton(Help help) {
    if (!help.isHelping) {
      this.showHelpButton = true;
      this.helpButtonText = "Help this customer";
    } else if (help.assistantName == this.assistantName) {
      this.showHelpButton = true;
      this.helpButtonText = "Resolve";
    } else {
      this.showHelpButton = false;
    }
  }

  void enteredName(String name, Function callback) async {
    this.assistantName = name;
    this.gotAssistantName = true;
    this.isLoading = true;
    callback();
    this.mapHelps = await database.getAllHelps();
    this.isLoading = false;
    callback();
    database.getAllHelpStream().listen((documents) {
      for (DocumentChange e in documents.docChanges) {
        if (e.type == DocumentChangeType.added ||
            e.type == DocumentChangeType.modified) {
          if (this.mapHelps.containsKey(e.doc.id)) {
            this
                .mapHelps[e.doc.id]!
                .update(e.doc.data() as Map<String, dynamic>);
            Help help = this.mapHelps[e.doc.id]!;
            this.updateHelpButton(help);
          } else {
            this.mapHelps[e.doc.id] =
                createHelp(e.doc.data() as Map<String, dynamic>);
          }
        }
        if (e.type == DocumentChangeType.removed) {
          this.mapHelps.remove(e.doc.id);
          this.indexExpanded = -1;
        }
      }
      callback();
    });
  }

  void expandHelp(int index, Help help, Function callback) {
    if (index == this.indexExpanded) {
      this.indexExpanded = -1;
      this.showHelpButton = false;
    } else {
      this.indexExpanded = index;
      database.getItem(help.plu).then(
          (value) => {this.isLoading = false, this.item = value, callback()});
      this.updateHelpButton(help);
    }
    callback();
  }

  void helpButtonClicked(Help help, Function callback) {
    if (!help.isHelping) {
      this.database.updatingHelp(help, this.assistantName);
    } else {
      this.database.removeHelp(help.id);
    }
    callback();
  }
}
