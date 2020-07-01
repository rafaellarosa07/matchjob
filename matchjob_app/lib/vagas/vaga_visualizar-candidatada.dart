import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:matchjob/model/usuario.dart';
import 'package:matchjob/model/vaga.dart';
import 'package:matchjob/usuario/minhas_vagas.dart';
import 'package:matchjob/util/server_request.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:matchjob/vagas/minhas_vagas_listagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VagaVisualizarCandidatada extends StatefulWidget {
  VagaVisualizarCandidatada({Key key, this.vaga}) : super(key: key);
  final Vaga vaga;

  @override
  _VagaVisualizarCandidatadaState createState() =>
      _VagaVisualizarCandidatadaState();
}

class _VagaVisualizarCandidatadaState extends State<VagaVisualizarCandidatada> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String contratante;
  final List<bool> isSelected = List.generate(2, (_) => false);
  final TextEditingController nomeController = new TextEditingController();
  final TextEditingController descricaoController = new TextEditingController();
  final TextEditingController valorController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController cidadeController = new TextEditingController();
  final TextEditingController ufController = new TextEditingController();
  final TextEditingController nomeEmpresaController =
  new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    widget.vaga;
    nomeController.text = widget.vaga.nome;
    descricaoController.text = widget.vaga.descricao;
    valorController.text = widget.vaga.valor;
    emailController.text = widget.vaga.email;
    nomeEmpresaController.text = widget.vaga.nomeEmpresa;
    cidadeController.text = widget.vaga.endereco.cidade.nome;
    ufController.text = widget.vaga.endereco.cidade.estado.uf;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Vaga",
          style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'MyFont'),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MinhasVagas()));
            }),
      ),
      backgroundColor: Colors.indigo[50],
      body: new SingleChildScrollView(
        child: new Form(
            key: _formKey,
            child: new Card(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: new Center(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Center(
                              child: Text(nomeController.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[400],
                                      fontSize: 34))),
                          Divider(
                            color: Colors.grey,
                            height: 5,
                            thickness: 1,
                            indent: 20,
                            endIndent: 0,
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Text(
                                          nomeEmpresaController.text,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18))),
                                  Text("   " + cidadeController.text,
                                      style:
                                      TextStyle(color: Colors.black, fontSize: 16)),
                                  Text(" - " + ufController.text,
                                      style:
                                      TextStyle(color: Colors.black, fontSize: 16))
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Text("Valor: R\$ " + valorController.text,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 16))),
                                  Text("Email: " + emailController.text,
                                      style:
                                      TextStyle(color: Colors.black, fontSize: 16))
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Text("Sobre a Vaga: ",
                                          style: TextStyle(fontWeight: FontWeight.bold,
                                              color: Colors.indigo[400], fontSize: 18)))
                                ],
                              )),
                          buildTexFieldDescricao(
                              "", descricaoController, TextInputType.text),
                          RaisedButton(
                            child: Text("Cancelar Candidatura",
                                style: TextStyle(fontSize: 15, color: Colors
                                    .white)),
                            color: Colors.indigo[400],
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              _showDialog();
                            },
                          ),
                        ],
                      )),
                ))),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Cancelar Candidatura"),
          content: Text("Deseja Cancelar candidatura dessa vaga?"),
          actions: [
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text("Cancelar Candidatura"),
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    duration: new Duration(seconds: 4),
                    content: new Row(
                      children: <Widget>[
                        new CircularProgressIndicator(),
                        new Text("  carregando...")
                      ],
                    ),
                  ));
                  _cancelarCandidatura().whenComplete(() => _closeLoading());
                })
          ],
        );
      },
    );
  }

  Widget buildTexFieldDescricao(String label, TextEditingController controller,
      TextInputType textInputType) {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: TextField(
                  enabled: false,
                  controller: descricaoController,
                  minLines: 10,
                  maxLines: 15,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Digite Aqui',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  )))
        ]);
  }

  _cancelarCandidatura() {
    _candidatarRequest("vaga", widget.vaga.id);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => MinhasVagas()),
            (Route<dynamic> route) => false);
  }


  Widget buildTexField(String label, TextEditingController controller,
      TextInputType textInputType) {
    return TextFormField(
      enabled: false,
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

  _toastSucesso() {
    Fluttertoast.showToast(
        msg: "Candidatura Cancelada!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _toastErro() {
    Fluttertoast.showToast(
        msg: "Erro no cancelamento da candidatura!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _closeLoading() {
    Navigator.of(context).pop();
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  _candidatarRequest(uri, id) async {
    int usuario;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usuario = sharedPreferences.get("pessoaLogada");

    String jsonResponse;

    var response = await http.get(
        Variavel.urlBase +
            "usuario/cancelar-candidatura/" +
            id.toString() +
            "/" +
            usuario.toString(),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      jsonResponse = response.body.isEmpty ? null : json.decode(response.body);
      _toastSucesso();
    }else{
      _toastErro();
    }
  }
}
