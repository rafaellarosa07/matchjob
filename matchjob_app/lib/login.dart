import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:matchjob/model/autenticar.dart';
import 'package:matchjob/usuario/usuario_cadastro.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home-contratante/home_contratante.dart';
import 'home-prestador/home_prestador.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  var passwordVisible = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  _login(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Autenticar autenticar = Autenticar(email, pass);
    String jsonAutenticar = jsonEncode(autenticar);

    Map<String, dynamic> jsonResponse = null;
    var response = await http.post(Variavel.urlBase + "usuario/autenticar",
        headers: {"Content-type": "application/json"}, body: jsonAutenticar);
    if (response.statusCode == 200) {
      jsonResponse = response.body == "" ? null : json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setInt("pessoaLogada", jsonResponse["id"]);
        sharedPreferences.setString(
            "pessoaLogadaObj", jsonEncode(jsonResponse));
        if (jsonResponse["tipoPessoa"] == "C") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeContratante()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePrestador()),
              (Route<dynamic> route) => false);
        }
      } else {
        _loginFailed();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          height: (MediaQuery.of(context).size.height),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.red])),
          child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
              child: new Form(
                  key: _formKey,
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Container(
                            height: (MediaQuery.of(context).size.height-500),
                            child: new Center(
                              child: Lottie.asset('images/coracao.json'),
                            ),
                            color: Colors.transparent,
                          ),
                          Text(
                            "Match Job",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'MyFont'),
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            controller: emailController,
                            validator: _validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.white),
                                icon: Icon(Icons.email, color: Colors.white70)),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: passwordVisible,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por Favor digite uma senha valida';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Icon(Icons.lock, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (_formKey.currentState.validate()) {
                                    _login(emailController.text,
                                        passwordController.text);
                                  }
                                },
                              )),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: FlatButton(
                                child: Text(
                                  "Cadastrar",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              UsuarioCadastro()),
                                      (Route<dynamic> route) => false);
                                },
                              ))
                        ],
                      ))))),
    );
  }

  _loginFailed() {
    Fluttertoast.showToast(
        msg: "Usuario ou Senha incorretos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Digite um Email";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email não é valido';
  }
}
