import 'package:cloud_firestore/cloud_firestore.dart';

import 'database.dart';
import 'help.dart';
import 'item.dart';

class ItemPageModel {
  final Item item;
  final DatabaseService database = new DatabaseService();
  String itemImageUrl = "";
  String itemName = "";
  String itemDescription = "";
  String itemPrice = "";
  String itemStockStatus = "";
  String itemLocation = "";
  String helpId = "";
  Help? help;
  String callForHelpButtonText = "Call for help";
  bool callForHelpButtonEnabled = true;
  Stream<DocumentSnapshot>? helpStream;

  ItemPageModel(this.item) {
    this.itemImageUrl = this.item.imageUrl;
    this.itemName = this.item.name;
    this.itemDescription = this.item.description;
    this.itemPrice = "Price: " + this.item.price;
    if (this.item.stock > 0) {
      this.itemStockStatus = "We have more of this item in the back. Ask us!";
    } else {
      this.itemStockStatus =
          "These are all we have. Grab them before they're gone!";
    }
    this.itemLocation = "You can find this item in aisle " + this.item.aisle;
  }

  void callForHelpButtonClicked(Function callback) {
    this.helpId = database.addHelpAndGetId(
        this.item.name, this.item.aisle, this.item.plu);
    this.callForHelpButtonEnabled = false;
    this.callForHelpButtonText = "An assistant will come to help you";
    callback();
    database.getHelpStream(this.helpId).listen((document) {
      if (document.exists) {
        this.help = createHelp(document.data());
        if (this.help!.isHelping) {
          this.callForHelpButtonText =
              this.help!.assistantName + " is coming to help you";
        }
      } else {
        this.callForHelpButtonText =
            this.help!.assistantName + " has helped you";
      }
      callback();
    });
  }
}
