import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:matchjob/model/cidade.dart';
import 'package:matchjob/model/endereco.dart';
import 'package:matchjob/model/estado.dart';
import 'package:matchjob/model/vaga.dart';
import 'package:matchjob/util/server_request.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:matchjob/vagas/candidatura_minhas_vagas.dart';
import 'package:matchjob/vagas/minhas_vagas_listagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VagaAlterar extends StatefulWidget {
  VagaAlterar({Key key, this.vaga}) : super(key: key);
  final Vaga vaga;

  @override
  _VagaAlterarState createState() => _VagaAlterarState();
}

class _VagaAlterarState extends State<VagaAlterar> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String contratante;
  final List<bool> isSelected = List.generate(2, (_) => false);
  final TextEditingController nomeController = new TextEditingController();
  final TextEditingController estadoController = new TextEditingController();
  final TextEditingController cidadeController = new TextEditingController();
  Cidade cidade ;
  final TextEditingController nomeEmpresaController =
      new TextEditingController();
  final TextEditingController descricaoController = new TextEditingController();
  final TextEditingController valorController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  static List<Estado> estados = new List<Estado>();
  static List<Cidade> cidades = new List<Cidade>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _selectedLocation;
  String _cidadeId;

  @protected
  @mustCallSuper
  void initState() {
    _preencherDados();
    estados = new List<Estado>();
    cidades = new List<Cidade>();
    _buscarEstados();
  }

  _preencherDados(){
    setState(() {
      widget.vaga;
      nomeController.text = widget.vaga.nome;
      descricaoController.text = widget.vaga.descricao;
      estadoController.text = widget.vaga.endereco.cidade.estado.nome;
      cidadeController.text = widget.vaga.endereco.cidade.nome;
      nomeEmpresaController.text = widget.vaga.nomeEmpresa;
      valorController.text = widget.vaga.valor;
      emailController.text = widget.vaga.email;
      _cidadeId = widget.vaga.endereco.cidade.id.toString();
    });
  }


  @override
  Widget build(BuildContext context) {


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
                  MaterialPageRoute(builder: (context) => VagaListagem()));
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
                  buildTexField("Nome", nomeController, TextInputType.text),
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
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: RaisedButton(
                          child: Text("Deletar",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white)),
                          color: Colors.indigo[400],
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            _showDialog("Confirmar Exclusão","Deseja confirmar a Exclusão da Vaga?","Deletar", 2);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: RaisedButton(
                          child: Text("Alterar",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white)),
                          color: Colors.indigo[400],
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_formKey.currentState.validate()) {
                              _showDialog("Confirmar Alteração","Deseja confirmar sua alteração?","Alterar", 1);
                            }
                          },
                        )),
                    RaisedButton(
                      child: Text("Visualizar Candidaturas",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                      color: Colors.indigo[400],
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _visualizarCandidaturas(widget.vaga);
                      },
                    ),
                  ])
                ],
              ),
            ))),
      ),
    );
  }

  _visualizarCandidaturas(Vaga vaga) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Candidaturas(vaga: vaga)));
  }

  Widget _dropDownMenu() {
    if (estados != null && estados.length > 0) {
      return DropdownButton<String>(
          hint: Text(widget.vaga.endereco.cidade.estado.nome),
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

  _buscarCidades(id) async {
    cidades = new List<Cidade>();
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

  _buscarEstados() async {
    estados = new List<Estado>();
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

  void _showDialog(String textoConfirmacao, String perguntaConfirmacao, String botaoText, int tipoMetodo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(textoConfirmacao),
          content: Text(perguntaConfirmacao),
          actions: [
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text(botaoText),
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(
                      new SnackBar(duration: new Duration(seconds: 4), content:
                      new Row(
                        children: <Widget>[
                          new CircularProgressIndicator(),
                          new Text("carregando...")
                        ],
                      ),
                      ));
                  if(tipoMetodo == 1){
                    _salvar().whenComplete(() =>
                        _preencherDados(),
                        _closeLoading()
                    );
                  }

                  if(tipoMetodo == 2){
                    _delete(widget.vaga.id).whenComplete(() =>
                        setState(() {
                          _closeLoading();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VagaListagem()));
                        })
                    );
                  }
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

  Widget _dropDownMenuCidades() {
      return DropdownButton<String>(
          hint: Text(widget.vaga.endereco.cidade.nome),
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

  }

  _salvar() async {
    int usuario;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usuario = sharedPreferences.get("pessoaLogada");
    Vaga vaga = Vaga(
        widget.vaga.id,
        nomeController.text,
        descricaoController.text,
        valorController.text,
        emailController.text,
        usuario,
        nomeEmpresaController.text,
        new Endereco(widget.vaga.endereco.id, cidade, int.parse(_cidadeId)));
    _alterarPost("vaga", jsonEncode(vaga));
  }

  _toastSucesso(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  _toastErro(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Widget buildTexField(String label, TextEditingController controller,
      TextInputType textInputType) {
    return TextFormField(
      maxLength: 100,
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
                  maxLength: 2000,
                  controller: descricaoController,
                  minLines: 10,
                  maxLines: 20,
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

  _alterarPost(uri, body) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonResponse;

    var response = await http.put(Variavel.urlBase + "vaga",
        headers: {"Content-type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      _toastSucesso("Alterado com Sucesso!!");
      jsonResponse = response.body.isEmpty ? null : json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _toastErro("Ocorreu um erro na Alteração");
    }
  }

  _delete(id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonResponse;

    var response = await http.delete(Variavel.urlBase + "vaga/" + id.toString(),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      _toastSucesso("Excluido com Sucesso!!");
      jsonResponse = response.body.isEmpty ? null : json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _toastErro("Ocorreu um erro na Exclusão");
    }
  }
}
