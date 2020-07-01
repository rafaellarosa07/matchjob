import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:matchjob/home-contratante/home_contratante.dart';
import 'package:matchjob/main.dart';
import 'package:matchjob/model/cidade.dart';
import 'package:matchjob/model/endereco.dart';
import 'package:matchjob/model/estado.dart';
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
  final TextEditingController nomeEmpresaController =
      new TextEditingController();
  final TextEditingController descricaoController = new TextEditingController();
  final TextEditingController valorController = new TextEditingController();
  final TextEditingController estadoController = new TextEditingController();
  final TextEditingController cidadeController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  static List<Estado> estados = new List<Estado>();
  static List<Cidade> cidades = new List<Cidade>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Cidade cidade;

  Estado estado;

  String _selectedLocation;
  String _cidadeId;

  @protected
  @mustCallSuper
  void initState() {
    estados = new List<Estado>();
    cidades = new List<Cidade>();
    _buscarEstados();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Cadastrar Vaga",
          style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'MyFont'),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeContratante()));
            }),
      ),
      backgroundColor: Colors.indigo[50],
      body: new SingleChildScrollView(
        child: new Form(
            key: _formKey,
            child: new Card(
                child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  buildTexField("Nome da Empresa", nomeEmpresaController,
                      TextInputType.text),
                  buildTexField(
                      "Nome da Vaga", nomeController, TextInputType.text),
                  buildTexField("Valor", valorController, TextInputType.text),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text(
                      "UF",
                      style: TextStyle(color: Colors.grey[800], fontSize: 18),
                    ),
                  ),
                  _dropDownMenu(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text(
                      "Cidade",
                      style: TextStyle(color: Colors.grey[800], fontSize: 18),
                    ),
                  ),
                  _dropDownMenuCidades(),
                  buildTexField(
                      "Email", emailController, TextInputType.emailAddress),
                  buildTexFieldDescricao(
                      "Descricao", descricaoController, TextInputType.text),
                  RaisedButton(
                    child: Text("Cadastrar",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    color: Colors.indigo[400],
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState.validate()) {
                        _showDialog();
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
    Vaga vaga = Vaga(
        null,
        nomeController.text,
        descricaoController.text,
        valorController.text,
        emailController.text,
        usuario,
        nomeEmpresaController.text,
        new Endereco(null, null, int.parse(_cidadeId)));
    _cadastrarPost("usuario", jsonEncode(vaga))
        .whenComplete(() =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => VagaListagem())));
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

  Widget buildTexFieldDescricao(String label, TextEditingController controller,
      TextInputType textInputType) {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Descrição",
                style: TextStyle(color: Colors.grey[800], fontSize: 18),
              )),
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

  _cadastrarPost(uri, body) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonResponse;

    var response = await http.post(Variavel.urlBase + "vaga",
        headers: {"Content-type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      _toastSucesso();
      jsonResponse = response.body.isEmpty ? null : json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _toastErro();
    }
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
                  _salvar().whenComplete(() =>
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


  _buscarEstados() async {
    List jsonResponse;

    var response = await http.get(Variavel.urlBase + "estado",
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      jsonResponse = response.body.isEmpty ? null : jsonDecode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        estados = jsonResponse.map((val) => Estado.fromJson(val)).toList();
      }
    }
  }

  _buscarCidades(id) async {
    List jsonResponse;

    var response = await http.get(Variavel.urlBase + "cidade/estado/" + id,
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      jsonResponse = response.body.isEmpty ? null : jsonDecode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        cidades = jsonResponse.map((val) => Cidade.fromJson(val)).toList();
      }
    }
  }

  Widget _dropDownMenu() {
    if (estados != null && estados.length > 0) {
      return DropdownButton<String>(
          hint: Text("Selecione"),
          items: estados.map((data) {
            return DropdownMenuItem<String>(
              value: data.id.toString(),
              child: Text(data.nome),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              cidades = new List<Cidade>();
              this._selectedLocation = newValue;
              _buscarCidades(newValue);
            });
          },
          value: _selectedLocation);
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget _dropDownMenuCidades() {
    if (cidades != null && cidades.length > 0) {
      return DropdownButton<String>(
          hint: Text("Selecione"),
          items: cidades.map((data) {
            return DropdownMenuItem<String>(
              value: data.id.toString(),
              child: Text(data.nome),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              this._cidadeId = newValue;
            });
          },
          value: _cidadeId);
    } else {
      return new IgnorePointer(
          ignoring: true,
          child: new DropdownButton(
            hint: new Text("Selecione"),
            items: ["asdf", "wehee", "asdf2", "qwer"].map(
              (String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text('$value'),
                );
              },
            ).toList(),
            onChanged: (value) {},
          ));
    }
  }
}
