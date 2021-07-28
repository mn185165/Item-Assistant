import 'dart:ui';
import 'package:flutter/material.dart';
import 'homePageModel.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  final model = new HomePageModel();

  @override
  _HomePageState createState() => _HomePageState(this.model);
}

class _HomePageState extends State<HomePage> {
  final HomePageModel model;
  _HomePageState(this.model);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(title: Text("Home")),
              body: HomePageBody(this.model));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Cannot initialize database"));
  }
}

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: controller.value,
    );
  }
}

class HomePageBody extends StatelessWidget {
  final HomePageModel model;

  HomePageBody(this.model);

  Widget customerButton(BuildContext context) {
    return TextButton(
        onPressed: () => this.model.cutomerButtonClicked(context),
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text("Customer")),
        style: TextButton.styleFrom(
          primary: Colors.white,
          fixedSize: Size(200, 50),
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        ));
  }

  Widget assistantButton(BuildContext context) {
    return TextButton(
        onPressed: () => this.model.assistantButtonClicked(context),
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text("Assistant")),
        style: TextButton.styleFrom(
          primary: Colors.white,
          fixedSize: Size(200, 50),
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: customerButton(context)),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: assistantButton(context))
      ],
    ));
  }
}
