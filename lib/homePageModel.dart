import 'package:flutter/material.dart';
//import 'qrScanner.dart';
import 'assistantPage.dart';
import 'scanItemPage.dart';

class HomePageModel {
  void cutomerButtonClicked(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScanItemPage()));
  }

  void assistantButtonClicked(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AssistantPage()));
  }
}
