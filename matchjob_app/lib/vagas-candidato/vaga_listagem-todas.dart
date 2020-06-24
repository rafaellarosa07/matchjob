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



  void _visualizarVaga(Vaga vaga) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => VagaVisualizar(vaga: vaga)),
            (Route<dynamic> route) => false);
  }

  Widget buildTex(String label, TextEditingController controller,
      TextInputType textInputType) {
    return Text(label,
      style: TextStyle(color: Colors.grey[800], fontSize: 18),
      textAlign: TextAlign.center,
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
          child: ListTile(
            //pego o nome do contato com base na posicao da lista
            title: Text(listaVaga[index].nome),

            //pego o email do contato com base na posicao da lista
            subtitle: Text(listaVaga[index].email),

            leading: CircleAvatar(
              //pego o nome do contato com base no indice
              // da lista e pego a primeira letra do nome
              child: Text(listaVaga[index].id.toString()),
            ),
          ),
          //clique longo para atualizar
          onTap: () => _visualizarVaga(listaVaga[index]),
          //clique curto para remover
        );
      },
    );
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
