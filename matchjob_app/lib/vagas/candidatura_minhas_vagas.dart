import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matchjob/model/usuario.dart';
import 'package:matchjob/model/vaga.dart';
import 'package:matchjob/pdf/pdf-view.dart';
import 'package:matchjob/util/variavel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'minhas_vagas_listagem.dart';


class Candidaturas extends StatefulWidget {
  Candidaturas({Key key, this.vaga}) : super(key: key);
  final Vaga vaga;

  @override
  _CandidaturasState createState() => _CandidaturasState();
}

class _CandidaturasState extends State<Candidaturas> {
  String assetPDFPath = "";
  String urlPDFPath = "";
  int tamanhoDaLista;
  bool _isLoading = false;
  List<Usuario> listaUsuario = new List<Usuario>();

  @override
  void initState() {
    _consultarCandidatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Candidatos",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.cyan[600],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => VagaListagem()));
              })),
      body: _listaDeCandidatos(),
    );;
  }

  Widget _listaDeCandidatos() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: listaUsuario.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                height: 120,
                width: double.maxFinite,
                child: Card(
                    elevation: 20,
                    child: new Container(
                        child: new Stack(
                          children: <Widget>[
                            Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(children: <Widget>[
                                          Icon(
                                            Icons.email,
                                            color: Colors.cyan[600],
                                            size: 40,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                80, 0, 0, 0),
                                            child: Row(children: <Widget>[
                                              Text(listaUsuario[index].nome,
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
                                  RaisedButton(
                                    color: Colors.cyan[600],
                                    child: Text("Visualizar Curriculo"),
                                    onPressed: () {
                                      if (urlPDFPath != null) {
                                        _getFile(listaUsuario[index].id);
                                      }
                                    },
                                  ),

                                ])
                          ],
                        )))));
      },
    );
  }


  Future<File> _getFileFromUrl(int idUsuario) async {
    try {
      var jsonResponse;
      var response = await  await http.get(
          Variavel.urlBase+"usuario/curriculo/" +idUsuario.toString(),
          headers: {"Content-type": "application/json"});
      if (response.statusCode == 200) {
        jsonResponse = response.body.isEmpty ? null : response.bodyBytes;
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          var bytes = response.bodyBytes;
          var dir = await getApplicationDocumentsDirectory();
          File file = new File("${dir.path}/curriculo.pdf");

          File urlFile = await file.writeAsBytes(bytes);
          return urlFile;
        }
      }

    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  String _getFile(int idUsuario){
    _getFileFromUrl(idUsuario).then((f) {
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) =>
            PdfViewPage(path: f.path, vaga: widget.vaga)));
      });
    });
  }

  _consultarCandidatos() async {
    int usuario;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usuario = sharedPreferences.get("pessoaLogada");
    List jsonResponse;

    var response = await http.get(
        Variavel.urlBase+"vaga/candidatos/" +widget.vaga.id.toString(),
        headers: {"Content-type": "application/json"});
    if (response.statusCode == 200) {
      jsonResponse = response.body.isEmpty ? null : jsonDecode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
          listaUsuario = jsonResponse.map((val) => Usuario.fromJson(val)).toList();
        });
      }
    }
  }
}
