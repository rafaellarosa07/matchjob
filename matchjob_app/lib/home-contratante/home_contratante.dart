import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matchjob/login.dart';

import 'home_contratante_front.dart';


class HomeContratante extends StatefulWidget {
  @override
  _HomeContratanteState createState() => new _HomeContratanteState();
}

class _HomeContratanteState extends State<HomeContratante>
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
        title: new Text("Match Job"),
        leading: Text(""),
        centerTitle: true,
        backgroundColor: Colors.cyan[600],
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