import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matchjob/model/vaga.dart';
import 'package:matchjob/usuario/minhas_vagas.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:matchjob/vagas-candidato/vaga_listagem-todas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:io';

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
  final TextEditingController nomeEmpresaController =
      new TextEditingController();
  final TextEditingController descricaoController = new TextEditingController();
  final TextEditingController valorController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController cidadeController = new TextEditingController();
  final TextEditingController ufController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File file;
  String fileName;

  @override
  Widget build(BuildContext context) {
    widget.vaga;
    nomeController.text = widget.vaga.nome;
    nomeEmpresaController.text = widget.vaga.nomeEmpresa;
    descricaoController.text = widget.vaga.descricao;
    valorController.text = widget.vaga.valor;
    emailController.text = widget.vaga.email;
    cidadeController.text = widget.vaga.endereco.cidade.nome;
    ufController.text = widget.vaga.endereco.cidade.estado.uf;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Vaga",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VagaListagemTodas()));
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
                    child: Text("Candidatar",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
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

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Envio da Candidatura"),
            content: Stack(
              children: <Widget>[
                Text("Selecione um Curriculo"),
                Padding(
                  padding: EdgeInsets.fromLTRB(75, 40, 0, 0),
                  child: RaisedButton(
                    color: Colors.indigo[400],
                    onPressed: () {
                      _upload(() => {
                            setState(() {
                              fileName = file.path.split("/").last;
                            })
                          });
                    },
                    child: Text('Carregar Imagem', style: TextStyle(color: Colors.white),),
                  ),
                ),
                showImage()
              ],
            ),
            actions: [
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text("Candidatar"),
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
                    _candidatar().whenComplete(() => _closeLoading());
                  })
            ],
          );
        });
      },
    );
  }

  Widget showImage() {
    if (fileName != null) {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 30),
          child: Card(
              color: Colors.indigo[100],
              child: Padding(
                  padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                  child: Text(fileName))));
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 30),
          child: Card(child: Text("Nenhum arquivo Selecionado")));
    }
  }

  _candidatar() {
    _candidatarRequest("vaga", widget.vaga.id);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => MinhasVagas()),
        (Route<dynamic> route) => false);
  }

  _upload(callBack) async {
    int usuario;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usuario = sharedPreferences.get("pessoaLogada");
    file = await FilePicker.getFile();
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var uri = Uri.parse(Variavel.urlBase +
        "usuario/curriculo/"+ usuario.toString()); //I get the URL from some config

    Map<String, String> headers = {"content-type": "multipart/form-data"};

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('file', stream, length, filename: "Curriculo-"+usuario.toString()+".pdf",
        contentType: new MediaType('multipart/form-data', 'pdf'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    callBack();
  }

  _toastSucesso() {
    Fluttertoast.showToast(
        msg: "Candidatura enviada!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _toastErro() {
    Fluttertoast.showToast(
        msg: "Erro no envio da candidatura!!",
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
            "usuario/candidatar/" +
            id.toString() +
            "/" +
            usuario.toString(),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      jsonResponse = response.body.isEmpty ? null : json.decode(response.body);
      _toastSucesso();
    } else {
      _toastErro();
    }
  }

  Widget buildTexField(String label, TextEditingController controller,
      TextInputType textInputType) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
      child: Row(children: <Widget>[
        Text(controller.text,
            style: TextStyle(color: Colors.black, fontSize: 18))
      ]),
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({this.onValueChange, this.initialValue});

  final String initialValue;
  final void Function(String) onValueChange;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("New Dialog"),
      children: <Widget>[
        new Container(
            padding: const EdgeInsets.all(10.0),
            child: new DropdownButton<String>(
              hint: const Text("Pick a thing"),
              value: _selectedId,
              onChanged: (String value) {
                setState(() {
                  _selectedId = value;
                });
                widget.onValueChange(value);
              },
              items:
                  <String>['One', 'Two', 'Three', 'Four'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            )),
      ],
    );
  }
}
