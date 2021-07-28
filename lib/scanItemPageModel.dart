import 'package:flutter/material.dart';
//import 'qrScanner.dart';
import 'item.dart';
import 'itemPage.dart';
import 'database.dart';

class ScanItemPageModel {
  DatabaseService data = new DatabaseService();
  void itemButtonClicked(BuildContext context, Item item) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ItemPage(item)));
  }

  Future<Item?> getItem(String plu) async {
    var item = await data.getItem(plu);
    if (item != null) {
      return item;
    }
    return null;
  }
}
