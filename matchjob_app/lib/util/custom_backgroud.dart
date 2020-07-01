import 'package:flutter/material.dart';

class CustomBackGround extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();



    // create the Shader from the gradient and the bounding square

//
    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Color.fromRGBO(238, 245, 255, 1.0);
    canvas.drawPath(mainBackground, paint);

    // center of the canvas is (x,y) => (width/2, height/2)
    //Circulo direito roxo
    var circulo1 = Offset(size.width / 1, size.height / 1);
    paint.color = Color.fromRGBO(43, 77, 255, 0.05);
    canvas.drawCircle(circulo1, 205.0, paint);

    //circulo esquerdo verde
    var circulo2 = Offset(size.width / 4, size.height / 1);
    paint.color = Color.fromRGBO(43, 244, 255, 0.05);
    canvas.drawCircle(circulo2, 155.0, paint);

    //Circulo Superior
//    var circulo3 = Offset(size.width / 69, size.height / 50);
//    paint.color = Color.fromRGBO(43, 244, 255, 0.07);
//    canvas.drawCircle(circulo3, 105.0, paint);

    //Circulo Superior Azul escuro
//    final Gradient gradient = new RadialGradient(
//      stops: [0.3, 1],
//      colors: [
//        Color.fromRGBO(22, 49, 119, 1.0),
//        Color.fromRGBO(238, 245, 255, 1.0)
//      ],
//    );
//    var circulo4 = Offset(size.width /2 , size.height/9 );
//    final Paint paint2 = new Paint()..shader =gradient.createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
//    canvas.drawCircle(circulo4, 930.0, paint2);

//    // Ondulação
    paint.color = Color.fromRGBO(43, 77, 255, 0.02);
    paint.style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, size.height * 0.9067);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9067);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
