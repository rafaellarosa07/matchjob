import 'package:flutter/material.dart';
import 'package:matchjob/util/server_request.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'package:matchjob/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:matchjob/vagas/vaga_cadastro.dart';
import 'package:matchjob/vagas/minhas_vagas_listagem.dart';


class HomeContratanteFront extends StatefulWidget {
  final AnimationController controller;

  HomeContratanteFront({this.controller});

  @override
  _HomeContratanteFrontState createState() => new _HomeContratanteFrontState();
}

class _HomeContratanteFrontState extends State<HomeContratanteFront> {
  static const header_height = 32.0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File file;
  var passwordVisible = true;
  var passwordConfirmVisible = true;
  String contratante;
  Usuario usuario;
  final List<bool> isSelected = List.generate(2, (_) => false);
  final TextEditingController nomeController = new TextEditingController();
  final TextEditingController passwordConfirmationController = new TextEditingController();
  final TextEditingController cnpjCpfController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  String tipoPessoa = "";

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return new RelativeRectTween(
            begin: new RelativeRect.fromLTRB(
                0.0, backPanelHeight, 0.0, frontPanelHeight),
            end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(new CurvedAnimation(
            parent: widget.controller, curve: Curves.linear));
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    return new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            color: Colors.cyan[600],
            child: new Center(child: _alterarPerfil()),
          ),
          new PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: new Material(
              elevation: 12.0,
              borderRadius: new BorderRadius.only(
                  topLeft: new Radius.circular(16.0),
                  topRight: new Radius.circular(16.0)),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: header_height,
                    child: new Center(
                      child: new Text(
                        "",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                  new Expanded(
                      child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 4.0, right: 4, bottom: 4, top: 300),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [],
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          delegate: SliverChildListDelegate(
                            [
                              BodyWidget(
                                  "Adicionar Vaga",
                                  "vagaCadastro",
                                  Icon(Icons.add_circle_outline,
                                      size: 80, color: Colors.white)),
                              BodyWidget(
                                  "Visualizar vagas",
                                  "vagasListagem",
                                  Icon(Icons.assignment,
                                      size: 80, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: bothPanels,
    );
  }

  _preencherUsuario() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usuario = Usuario.fromJson(
        jsonDecode(sharedPreferences.getString("pessoaLogadaObj")));
    nomeController.text = usuario.nome;
    cnpjCpfController.text = usuario.cpfCnpj;
    emailController.text = usuario.email;
  }

  Widget _alterarPerfil() {
    return new SingleChildScrollView(
        child: new Form(
            key: _formKey,
            child: new Column(children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                        "Confirme a Senha", passwordConfirmationController, TextInputType.text),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: ToggleButtons(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Quero Contratar")),
                          Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Quero ser Contratado")),
                        ],
                        borderColor: Colors.white,
                        selectedBorderColor: Colors.white,
                        borderWidth: 2,
                        highlightColor: Colors.white,
                        color: Colors.white,
                        fillColor: Colors.white,
                        selectedColor: Colors.cyan[600],
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
                    buildTexFieldCpfCnpj(
                        "CPF", cnpjCpfController, TextInputType.text),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: _choose,
                          child: Text('Choose Image'),
                        ),
                        SizedBox(width: 10.0),
                        RaisedButton(
                          onPressed: _upload,
                          child: Text('Upload Image'),
                        )
                      ],
                    ),
                    RaisedButton(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(140, 10, 140, 10),
                          child: Text("Alterar",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      color: Colors.cyan[600],
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        if (_formKey.currentState.validate()) {
                          _alterar();
                        }
                      },
                    )
                  ],
                ),
              ),
            ])));
  }

  void navigateToView(BuildContext context, String navigationKey) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          if (navigationKey == "vagaCadastro") {
            return VagaCadastro();
          } else {
            return VagaListagem();
          }
        },
        transitionsBuilder: (context, animation1, animation2, child) {
          return FadeTransition(
            opacity: animation1,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _preencherUsuario();
  }

  _alterar() {
    Usuario usuario = Usuario(this.usuario.id, nomeController.text, cnpjCpfController.text,
        tipoPessoa, emailController.text, passwordController.text);
    _alterarRequest("usuario", jsonEncode(usuario));
//    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
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
          labelText: label, labelStyle: TextStyle(color: Colors.white)),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  Widget buildTexFieldPassConfirmation(String label, TextEditingController controller,
      TextInputType textInputType) {
    return TextFormField(
      obscureText: passwordConfirmVisible,
      controller: controller,
      validator: (val){
        if(val.isEmpty)
          return 'Vazio';
        if(val != passwordController.text)
          return 'A confirmação de Senha não Confere';
        return null;
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            passwordConfirmVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.white,
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
        labelStyle: TextStyle(color: Colors.white),
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
          labelText: label, labelStyle: TextStyle(color: Colors.white)),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  void _choose() async {
    file = await FilePicker.getFile();
  }

  _upload() async {
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var uri = Uri.parse(
        Variavel.urlBase+"usuario/curriculo/"); //I get the URL from some config

    Map<String, String> headers = {"content-type": "multipart/form-data"};

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('file', stream, length,
        contentType: new MediaType('multipart/form-data', 'pdf'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
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
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTexField("CPF/CNPJ", controller, TextInputType.text),
        ],
      );
    } else {
      return Text(
        "TESTE",
        style: TextStyle(fontSize: 1),
      );
    }
  }

  _alterarRequest(uri, body) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonResponse;

    var response = await http.put(Variavel.urlBase+"usuario",
        headers: {"Content-type": "application/json"}, body: body);
    if (response.statusCode == 200) {
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
    }
  }
}

class HeaderWidget extends StatelessWidget {
  final String text;

  HeaderWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 2, top: 20),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
            color: Colors.cyan[600], fontSize: 16, fontWeight: FontWeight.bold),
      ),
      color: Colors.white,
    );
  }
}

class BodyWidget extends StatelessWidget {
  final Icon icon;
  final String title;
  final String navigationKey;

  BodyWidget(this.title, this.navigationKey, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Card(
          color: Colors.cyan[600],
          elevation: 5,
          child: InkWell(
            onTap: () {
              navigateToView(context, navigationKey);
            },
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child:
                  Container(margin: EdgeInsets.only(top: 40), child: icon),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    verticalDirection: VerticalDirection.up,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.black.withOpacity(.2),
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void navigateToView(BuildContext context, String navigationKey) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          if (navigationKey == "vagaCadastro") {
            return VagaCadastro();
          } else {
            return VagaListagem();
          }
        },
        transitionsBuilder: (context, animation1, animation2, child) {
          return FadeTransition(
            opacity: animation1,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 600),
      ),
    );
  }
}