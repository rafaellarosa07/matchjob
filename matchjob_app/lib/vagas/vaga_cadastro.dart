import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:matchjob/home-contratante/home_contratante.dart';
import 'package:matchjob/main.dart';
import 'package:matchjob/model/endereco.dart';
import 'package:matchjob/model/vaga.dart';
import 'package:matchjob/util/server_request.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:matchjob/vagas/minhas_vagas_listagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VagaCadastro extends StatefulWidget {
  @override
  _VagaCadastroState createState() => _VagaCadastroState();
}

class _VagaCadastroState extends State<VagaCadastro> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String contratante;
  final List<bool> isSelected = List.generate(2, (_) => false);
  final TextEditingController nomeController = new TextEditingController();
  final TextEditingController nomeEmpresaController = new TextEditingController();
  final TextEditingController descricaoController = new TextEditingController();
  final TextEditingController valorController = new TextEditingController();
  final TextEditingController cepController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastrar Vaga",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[600],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeContratante()));
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
                  buildTexField("Nome da Empresa", nomeEmpresaController, TextInputType.text),
                  buildTexField("CEP", cepController, TextInputType.text),
                  buildTexField("Nome", nomeController, TextInputType.text),
                  buildTexField(
                      "Descricao", descricaoController, TextInputType.text),
                  buildTexField("Valor", valorController, TextInputType.text),
                  buildTexField(
                      "Email", emailController, TextInputType.emailAddress),
                  RaisedButton(
                    child: Text("Cadastrar",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    color: Colors.cyan[600],
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState.validate()) {
                        _salvar();
                      }
                    },
                  ),
                ],
              ),
            ))),
      ),
    );
  }

  _salvar() async {
    int usuario;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usuario = sharedPreferences.get("pessoaLogada");
    Vaga vaga = Vaga(null,nomeController.text, descricaoController.text,
        valorController.text, emailController.text,usuario, nomeEmpresaController.text,  new Endereco(null, cepController.text, null, null));
    _cadastrarPost("vaga", jsonEncode(vaga));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => VagaListagem()),
        (Route<dynamic> route) => false);
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

  _cadastrarPost(uri, body) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonResponse;

    var response = await http.post(Variavel.urlBase+"vaga",
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
