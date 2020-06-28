import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:matchjob/model/usuario.dart';
import 'package:matchjob/model/vaga.dart';
import 'package:matchjob/usuario/minhas_vagas.dart';
import 'package:matchjob/util/server_request.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:matchjob/vagas/minhas_vagas_listagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VagaVisualizar extends StatefulWidget {
  VagaVisualizar({Key key, this.vaga}) : super(key: key);
  final Vaga vaga;

  @override
  _VagaVisualizarState createState() => _VagaVisualizarState();
}

class _VagaVisualizarState extends State<VagaVisualizar> {
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

  @override
  Widget build(BuildContext context) {
    widget.vaga;
    nomeController.text = widget.vaga.nome;
    descricaoController.text = widget.vaga.descricao;
    valorController.text = widget.vaga.valor;
    emailController.text = widget.vaga.email;
    cidadeController.text = widget.vaga.endereco.cidade.nome;
    ufController.text = widget.vaga.endereco.cidade.estado.uf;

    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Vaga",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[600],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MinhasVagas()));
            }),
      ),
      backgroundColor: Colors.grey[300],
      body: new SingleChildScrollView(
        child: new Form(
            key: _formKey,
            child: new Card(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildTexField("Nome", nomeController, TextInputType.text),
                      estadoCidade(),
                      buildTexField(
                          "Valor", valorController, TextInputType.text),
                      buildTexField(
                          "Email", emailController, TextInputType.emailAddress),
                      buildTexFieldDescricao(
                          "", descricaoController, TextInputType.text),
                      RaisedButton(
                        child: Text("Candidatar",
                            style: TextStyle(
                                fontSize: 15, color: Colors.white)),
                        color: Colors.cyan[600],
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _candidatar();
                        },
                      ),
                    ],
                  ),
                ))),
      ),
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

  _candidatar() {
    _candidatarRequest("vaga", widget.vaga.id);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => MinhasVagas()),
            (Route<dynamic> route) => false);
  }

  Widget estadoCidade() {
    return Row(
      children: <Widget>[
        buildTexField("Cidade", cidadeController, TextInputType.emailAddress),
        buildTexField("UF", ufController, TextInputType.emailAddress),
      ],
    );
  }
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

_candidatarRequest(uri, id) async {
  int usuario;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  usuario = sharedPreferences.get("pessoaLogada");

  String jsonResponse;

  var response = await http.get(
      Variavel.urlBase + "usuario/candidatar/" + id.toString() + "/" +
          usuario.toString(),
      headers: {"Content-type": "application/json"});
  if (response.statusCode == 200) {
    jsonResponse = response.body.isEmpty ? null : json.decode(response.body);
  }
}
