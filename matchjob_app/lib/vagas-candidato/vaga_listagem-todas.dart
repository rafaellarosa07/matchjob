import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matchjob/model/vaga.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:matchjob/vagas/vaga_visualizar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class VagaListagemTodas extends StatefulWidget {
  @override
  _VagaListagemTodasState createState() => _VagaListagemTodasState();
}

class _VagaListagemTodasState extends State<VagaListagemTodas> {
  int tamanhoDaLista = 0;
  bool _isLoading = false;
  static List<Vaga> newDataList = new List<Vaga>();
  List<Vaga> listaVaga = List.from(newDataList);
  final _email = TextEditingController();
  final _nome = TextEditingController();
  final _valor = TextEditingController();
  final _descricao = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _consultarVagas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new TextField(
            style: TextStyle(color: Colors.white, fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              hintStyle: TextStyle(
                  fontFamily: "WorkSansSemiBold", fontSize: 17.0, color: Colors.white),

            ),
            onChanged: onItemChanged),
        centerTitle: true,
        backgroundColor: Colors.cyan[600],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              })
      ),
      body: _listaDeVagas(),

    );
  }



  onItemChanged(String value) {
    setState(() {
      listaVaga  = newDataList
          .where((string) => string.nome.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }


  Widget _listaDeVagas() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: listaVaga.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () => _visualizarVaga(listaVaga[index]),
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                height: 180,
                width: double.maxFinite,
                child: Card(
                    elevation: 20,
                    child: new Container(
                        child: new Stack(
                          children: <Widget>[
                            Column(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(children: <Widget>[
                                      Icon(
                                        Icons.email,
                                        color: Colors.cyan[600],
                                        size: 40,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(80, 0, 0, 0),
                                        child: Row(children: <Widget>[
                                          Text(listaVaga[index].nome,
                                              style: TextStyle(
                                                  color: Colors.black,
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
                                      Text(listaVaga[index].endereco.cidade.nome,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14))
                                    ]),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Row(children: <Widget>[
                                      Text("R\$ ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14))
                                    ]),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(children: <Widget>[
                                      Text(listaVaga[index].valor,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14))
                                    ]),
                                  )
                                ],
                              )

                            ])
                          ],
                        )))));
      },
    );
  }



  void _visualizarVaga(Vaga vaga) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => VagaVisualizar(vaga: vaga)),
            (Route<dynamic> route) => false);
  }

  _consultarVagas() async {
    int usuario;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usuario = sharedPreferences.get("pessoaLogada");
    List jsonResponse;

    var response = await http.get(Variavel.urlBase+"vaga/listar/"+usuario.toString(),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      jsonResponse = response.body.isEmpty ? null : jsonDecode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        newDataList = jsonResponse.map((val) =>  Vaga.fromJson(val)).toList();
        listaVaga = List.from(newDataList);
      }
    }
  }
}
