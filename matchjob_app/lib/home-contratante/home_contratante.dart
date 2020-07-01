import 'package:flutter/material.dart';
import 'package:matchjob/home-contratante/home_contratante_front.dart';


class HomeContratante extends StatefulWidget {
  @override
  _HomePrestadorState createState() => new _HomePrestadorState();
}

class _HomePrestadorState extends State<HomeContratante>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 100), value: 1.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  bool get isPanelVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Match Job", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'MyFont'),),
        leading: Text(""),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              controller.fling(velocity: isPanelVisible ? -1.0 : 1.0);
            },
            icon: new AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: controller.view,
            ),
          )],
      ),
      body: new HomeContratanteFront(
        controller: controller,
      ),
    );
  }

}