import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'help.dart';
import 'item.dart';

class DatabaseService {
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  CollectionReference helps = FirebaseFirestore.instance.collection('helps');

  Future<Item?> getItem(String plu) async {
    DocumentSnapshot snapshot = await items.doc(plu).get();

    if (snapshot.exists) {
      Item item = createItem(snapshot.data());
      return item;
    }
    return null;
  }

  String addHelpAndGetId(String itemName, String aisle, String plu) {
    Help help = new Help(itemName, aisle, plu);
    DocumentReference ref = helps.doc();
    help.id = ref.id;
    var returnValue = ref.set(help.toJson());
    return ref.id;
  }

  void updatingHelp(Help help, String assistantName) {
    help.assistantName = assistantName;
    help.isHelping = true;
    this.helps.doc(help.id).update(help.toJson());
  }

  void removeHelp(String id) {
    this.helps.doc(id).delete();
  }

  Future<Map<String, Help>> getAllHelps() async {
    QuerySnapshot querySnapshot = await helps.get();

    Map<String, Help> mapHelps = {};
    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((element) {
        Help help = createHelp(element.data());
        help.id = element.id;
        mapHelps[help.id] = help;
      });
    }
    return mapHelps;
  }

  Stream<DocumentSnapshot> getHelpStream(String id) {
    return helps.doc(id).snapshots();
  }

  Stream<QuerySnapshot> getAllHelpStream() {
    return helps.snapshots();
  }
}
