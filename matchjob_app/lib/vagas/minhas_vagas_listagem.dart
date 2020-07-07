import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchjob/home-contratante/home_contratante.dart';
import 'package:matchjob/model/vaga.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:matchjob/vagas/vaga_alterar.dart';
import 'package:matchjob/vagas/vaga_cadastro.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class VagaListagem extends StatefulWidget {
  @override
  _VagaListagemState createState() => _VagaListagemState();
}

class _VagaListagemState extends State<VagaListagem> {
  int tamanhoDaLista;
  bool _isLoading = false;
  static List<Vaga> newDataList = new List<Vaga>();
  List<Vaga> listaVaga = List.from(newDataList);
  final _email = TextEditingController();
  final _nome = TextEditingController();
  final _valor = TextEditingController();
  final _descricao = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 4), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  carregando...")
          ],
        ),
        ));
    _consultarVagas().whenComplete(()=>
      _closeLoading()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
          title: new TextField(
              style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'MyFont'),
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                  hintStyle: TextStyle(
                      fontFamily: "WorkSansSemiBold", fontSize: 17.0, color: Colors.white),

              ),
              onChanged: onItemChanged),
          centerTitle: true,
          backgroundColor: Colors.indigo[400],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeContratante()));
              })),
      body: _listaDeVagas(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _adicionarVaga(); //chamo o AlertDialog
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo[400],
      ),
    );
  }

  void _adicionarVaga() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => VagaCadastro()),
        (Route<dynamic> route) => false);
  }

  Widget buildTexField(String label, TextEditingController controller,
      TextInputType textInputType) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value.isEmpty && value.length == 0) {
          return "Campo Obrigatório"; // retorna a mensagem
          //caso o campo esteja vazio
        }
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey[800])),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[800], fontSize: 18),
    );
  }

  Widget _listaDeVagas() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: listaVaga.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () => _atualizarVaga(listaVaga[index]),
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                height: 150,
                width: double.maxFinite,
                child: Card(
                    elevation: 20,
                    child: new Container(
                        child: new Stack(
                          children: <Widget>[
                            Column(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(children: <Widget>[
                                      Icon(
                                        Icons.email,
                                        color: Colors.indigo[400],
                                        size: 40,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(90, 0, 0, 0),
                                        child: Row(children: <Widget>[
                                          Text(listaVaga[index].nome,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo[600],
                                                  fontSize: 18))
                                        ]),
                                      )
                                    ])),
                              ),
                              Divider(
                                color: Colors.grey,
                                height: 5,
                                thickness: 1,
                                indent: 20,
                                endIndent: 0,
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Row(children: <Widget>[
                                      Text(listaVaga[index].nomeEmpresa,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16))
                                    ]),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Row(children: <Widget>[
                                      Text(listaVaga[index].endereco.cidade.nome,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16))
                                    ]),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Row(children: <Widget>[
                                      Text("R\$ ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18))
                                    ]),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(children: <Widget>[
                                      Text(listaVaga[index].valor,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16))
                                    ]),
                                  )

                                ],
                              ),
                            ])
                          ],
                        )))));
      },
    );
  }

  _atualizarVaga(Vaga vaga) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => VagaAlterar(vaga: vaga)),
        (Route<dynamic> route) => false);
  }



  onItemChanged(String value) {
    setState(() {
      listaVaga = newDataList
          .where((string) => string.nome.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  _consultarVagas() async {
    int usuario;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usuario = sharedPreferences.get("pessoaLogada");

    var response ;
    response = await http.get(
        Variavel.urlBase +
            "vaga/minhas-vagas-cadastradas/" +
            usuario.toString(),
        headers: {"Content-type": "application/json"}).whenComplete(() =>
    _verificarResponse(response));
  }
  _closeLoading() {
    Navigator.of(context).pop();
    _scaffoldKey.currentState.hideCurrentSnackBar();

  }
  _verificarResponse(var response){
    List jsonResponse;
    if (response.statusCode == 200 || response.statusCode == 204) {
      jsonResponse = response.body.isEmpty ? null : jsonDecode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
          newDataList = jsonResponse.map((val) => Vaga.fromJson(val)).toList();
          listaVaga = List.from(newDataList);
        });
      }else{
        setState(() {
          newDataList = new List<Vaga>();
          listaVaga = List.from(newDataList);
        });
      }
    }
  }

}
