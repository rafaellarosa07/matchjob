import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matchjob/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:matchjob/util/server_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:matchjob/vagas/minhas_vagas_listagem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';

import '../login.dart';

class UsuarioCadastro extends StatefulWidget {
  @override
  _UsuarioCadastroState createState() => _UsuarioCadastroState();
}

class _UsuarioCadastroState extends State<UsuarioCadastro> {

  bool _validateSenha = false;
  var passwordVisible = true;
  var passwordConfirmVisible = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File file;
  String contratante;
  final List<bool> isSelected = List.generate(2, (_) => false);
  final TextEditingController nomeController = new TextEditingController();
  final TextEditingController cnpjCpfController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordConfirmationController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _mensagemSenha;
  String tipoPessoa = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Cadastrar",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[600],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            }),
      ),
      backgroundColor: Colors.white,
      body: new SingleChildScrollView(
          child: new Form(
              key: _formKey,
              child: new Column(children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildTexField("Nome", nomeController, TextInputType.text),
                      buildTexFieldEmail(
                          "Email", emailController, TextInputType.emailAddress),
                      buildTexFieldPass(
                          "Senha", passwordController, TextInputType.text),
                      buildTexFieldPassConfirmation(
                          "Confirme a Senha", passwordConfirmationController,
                          TextInputType.text),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: ToggleButtons(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                                child: Text("Quero Contratar")),
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text("Quero ser Contratado")),
                          ],
                          borderColor: Colors.cyan[600],
                          selectedBorderColor: Colors.cyan[600],
                          borderWidth: 2,
                          highlightColor: Colors.cyan[600],
                          color: Colors.cyan[600],
                          fillColor: Colors.cyan[600],
                          selectedColor: Colors.white,
                          isSelected: isSelected,
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                              buttonIndex < isSelected.length;
                              buttonIndex++) {
                                if (buttonIndex == index) {
                                  if (index == 0) {
                                    contratante = "C";
                                    tipoPessoa = contratante;
                                  } else {
                                    tipoPessoa = "P";
                                    contratante = "P";
                                    cnpjCpfController.text = "";
                                  }
                                  isSelected[buttonIndex] = true;
                                } else {
                                  isSelected[buttonIndex] = false;
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                buildTexFieldCpfCnpj(
                    "CPF", cnpjCpfController, TextInputType.number),
                SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RaisedButton(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(140, 10, 140, 10),
                                child: Text("Cadastrar",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                            color: Colors.cyan[600],
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_formKey.currentState.validate()) {
                              _showDialog();
                              }
                            },
                          ),
                        ])),
              ]))),
    );
  }


  Future _cadastrar() async {
    Usuario usuario = Usuario(null, nomeController.text, cnpjCpfController.text,
        tipoPessoa, emailController.text, passwordController.text);
    _cadastrarPost("usuario", jsonEncode(usuario))
        .whenComplete(() =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login())));
  }

  Widget buildTexField(String label, TextEditingController controller,
      TextInputType textInputType) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return 'Por Favor digite um valor valido';
        }
        return null;
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey[800])),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[800], fontSize: 18),
    );
  }

  Widget buildTexFieldPassConfirmation(String label,
      TextEditingController controller,
      TextInputType textInputType) {
    return TextFormField(
      obscureText: passwordConfirmVisible,
      controller: controller,
      validator: (val) {
        if (val.isEmpty)
          return 'Vazio';
        if (val != passwordController.text)
          return 'A confirmação de Senha não Confere';
        return null;
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[800]),
        errorText: _validateSenha ? _mensagemSenha : null,
        suffixIcon: IconButton(
          icon: Icon(
            passwordConfirmVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.cyan[600],
          ),
          onPressed: () {
            setState(() {
              passwordConfirmVisible = !passwordConfirmVisible;
            });
          },
        ),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[800], fontSize: 18),
    );
  }

  Widget buildTexFieldPass(String label, TextEditingController controller,
      TextInputType textInputType) {
    return TextFormField(
      obscureText: passwordVisible,
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return 'Por Favor digite um valor valido';
        }
        return null;
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[800]),
        errorText: _validateSenha ? _mensagemSenha : null,
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.cyan[600],
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[800], fontSize: 18),
    );
  }

  Widget buildTexFieldEmail(String label, TextEditingController controller,
      TextInputType textInputType) {
    return TextFormField(
      controller: controller,
      validator: _validateEmail,
      keyboardType: textInputType,
      decoration: InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey[800])),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[800], fontSize: 18),
    );
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

  Widget buildTexFieldCpfCnpj(String label, TextEditingController controller,
      TextInputType textInputType) {
    if (contratante == "C") {
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildTexField("CPF/CNPJ", controller, TextInputType.text),
          ],
        ),
      );
    } else {
      return Text(
        "TESTE",
        style: TextStyle(fontSize: 1),
      );
    }
  }

  _cadastrarPost(uri, body) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonResponse;

    var response = await http.post(Variavel.urlBase + "usuario",
        headers: {"Content-type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      _toastSucesso();
      jsonResponse = response.body.isEmpty ? null : json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => VagaListagem()),
                (Route<dynamic> route) => false);
      }
    } else {
      _toastErro();
    }
  }


  _toastSucesso() {
    Fluttertoast.showToast(
        msg: "Cadastro realizado com sucesso!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  _toastErro() {
    Fluttertoast.showToast(
        msg: "Erro ao Cadastrar!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return
          new CircularProgressIndicator();
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      _cadastrar();
    });
  }


  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Confirmar Cadastro"),
          content: Text("Deseja confirmar seu cadastro ?"),
          actions: [
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text("Cadastrar"),
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(
                      new SnackBar(duration: new Duration(seconds: 4), content:
                      new Row(
                        children: <Widget>[
                          new CircularProgressIndicator(),
                          new Text("  carregando...")
                        ],
                      ),
                      ));
                  _cadastrar().whenComplete(() =>
                      _closeLoading()
                  );
                }
            )
          ],
        );
      },
    );
  }

  _closeLoading() {
    Navigator.of(context).pop();
    _scaffoldKey.currentState.hideCurrentSnackBar();

  }
}


