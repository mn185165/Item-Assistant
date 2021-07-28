import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/itemPageModel.dart';
import 'item.dart';

class ItemPage extends StatelessWidget {
  final Item item;
  ItemPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Item')),
        body: ItemView(new ItemPageModel(this.item)));
  }
}

class ItemView extends StatefulWidget {
  final ItemPageModel model;
  ItemView(this.model);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  Widget buildCallForHelpButton() {
    var isEnabled = widget.model.callForHelpButtonEnabled;
    var callForHelpButtonText = widget.model.callForHelpButtonText;

    void update() {
      setState(() {
        callForHelpButtonText = widget.model.callForHelpButtonText;
        isEnabled = widget.model.callForHelpButtonEnabled;
      });
    }

    return TextButton(
        onPressed: (isEnabled)
            ? () => {widget.model.callForHelpButtonClicked(update)}
            : null,
        child: Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Text(callForHelpButtonText,
                style: TextStyle(fontSize: 17, color: Colors.white))),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: (isEnabled) ? Colors.blue : Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      addAutomaticKeepAlives: false,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Container(
                height: 200,
                width: 200,
                child: Image.network(
                  widget.model.itemImageUrl,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : Center(
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator()));
                  },
                ))),
        Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(widget.model.itemName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(widget.model.itemDescription,
                style: TextStyle(fontSize: 15))),
        Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child:
                Text(widget.model.itemPrice, style: TextStyle(fontSize: 20))),
        Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(widget.model.itemStockStatus,
                style: TextStyle(fontSize: 15))),
        Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(widget.model.itemLocation,
                style: TextStyle(fontSize: 15))),
        Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
            alignment: Alignment.center,
            child: buildCallForHelpButton())
      ],
    );
  }
}
