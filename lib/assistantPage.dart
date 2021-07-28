import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/assistantPageModel.dart';

import 'help.dart';
import 'item.dart';

class AssistantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Assistant')),
        body: AssistantView(new AssistantPageModel()));
  }
}

class AssistantView extends StatefulWidget {
  final AssistantPageModel model;
  AssistantView(this.model);

  @override
  _AssistantViewState createState() => _AssistantViewState();
}

class _AssistantViewState extends State<AssistantView> {
  final inputController = TextEditingController();
  String assistantName = "";
  bool gotAssistantName = false;
  bool isLoading = false;
  int indexExpanded = -1;
  ScrollController scrollController = ScrollController();
  double maxScroll = 0;
  String helpButtonText = "";

  Map<String, Help> mapHelps = {};

  void update() {
    setState(() {
      this.gotAssistantName = widget.model.gotAssistantName;
      this.assistantName = widget.model.assistantName;
      this.isLoading = widget.model.isLoading;
      this.mapHelps = widget.model.mapHelps;
      this.helpButtonText = widget.model.helpButtonText;
      this.indexExpanded = widget.model.indexExpanded;
    });
  }

  void expand() {
    setState(() {
      this.indexExpanded = widget.model.indexExpanded;
      this.isLoading = widget.model.isLoading;
      this.helpButtonText = widget.model.helpButtonText;
    });
    if (this.indexExpanded != -1) {
      double eachItem =
          this.scrollController.position.maxScrollExtent / this.mapHelps.length;
      double spacing = this.indexExpanded * 10;
      double scrollTo = this.indexExpanded * eachItem + spacing;
      this.scrollController.animateTo(scrollTo,
          duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    }
  }

  Widget buildAssistantInput() {
    return Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        alignment: Alignment.center,
        child: TextField(
            controller: this.inputController,
            decoration: InputDecoration(
                labelText: widget.model.inputText,
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  splashColor: Colors.blue,
                  onPressed: () =>
                      widget.model.enteredName(inputController.text, update),
                ))));
  }

  Widget buildExpandedHelpView(Item? item, Help help) {
    if (item == null) {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator())));
    } else {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(children: [
            Expanded(
                child: ListView(
                    addAutomaticKeepAlives: false,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                      child: Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            item.imageUrl,
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
                      child: Text(item.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text("Description: " + item.description,
                          style: TextStyle(fontSize: 15))),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(" Price: " + item.price,
                          style: TextStyle(fontSize: 20))),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text("Stock: " + item.stock.toString(),
                          style: TextStyle(fontSize: 15))),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text("Aisle: " + item.aisle,
                          style: TextStyle(fontSize: 15)))
                ])),
            buildHelpButton(help)
          ]));
    }
  }

  Widget buildHelpButton(Help help) {
    if (widget.model.showHelpButton) {
      return TextButton(
          onPressed: () => widget.model.helpButtonClicked(help, update),
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Text(this.helpButtonText,
                  style: TextStyle(fontSize: 17, color: Colors.white))),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
          ));
    } else {
      return Container();
    }
  }

  Widget buildListHelps() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return (SizedBox(height: 10));
            },
            controller: this.scrollController,
            itemCount: this.mapHelps.length,
            itemBuilder: (context, index) {
              Help help = this.mapHelps.values.elementAt(index);
              return Card(
                  child: Column(children: [
                ListTile(
                    leading: Icon(Icons.live_help, color: Colors.blue),
                    trailing: RotatedBox(
                        quarterTurns: (index != this.indexExpanded) ? 0 : 2,
                        child: IconButton(
                            icon: Icon(Icons.arrow_drop_down_circle,
                                color: Colors.blue),
                            onPressed: () => widget.model
                                .expandHelp(index, help, this.expand))),
                    title: Text(help.itemName + " in aisle " + help.aisle),
                    subtitle: (help.isHelping)
                        ? ((help.assistantName == widget.model.assistantName)
                            ? Text("Status: You are helping this customer",
                                style: TextStyle(color: Colors.blue))
                            : Text("Status: " +
                                help.assistantName +
                                " is helping this customer"))
                        : Text("Status: A customer is needing help",
                            style: TextStyle(color: Colors.green))),
                (index == this.indexExpanded)
                    ? buildExpandedHelpView(this.widget.model.item, help)
                    : Container()
              ]));
            }));
  }

  Widget buildAssistantView() {
    return (this.isLoading)
        ? Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()))
        : Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Center(
                      child: Text("Hello, " + this.assistantName + "!",
                          style: TextStyle(fontSize: 22)))),
              Expanded(child: buildListHelps())
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return (this.gotAssistantName)
        ? buildAssistantView()
        : buildAssistantInput();
  }
}
