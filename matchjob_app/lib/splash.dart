import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:matchjob/login.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 40)).then((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.indigo[400],
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            child: new Container(
              height: (MediaQuery.of(context).size.height-500),
              child: new Center(
                child: Lottie.asset('images/coracao.json'),
              ),
              color: Colors.transparent,
            ),
          ),
        )
    );
  }
}
