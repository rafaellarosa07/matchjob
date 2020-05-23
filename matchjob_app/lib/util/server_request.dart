//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:http/http.dart' as http;
//import 'package:matchjob/main.dart';
//import 'package:matchjob/model/autenticar.dart';
//import 'package:matchjob/util/variavel.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//const url = Variavel.urlBase+"";
//
//class ServerRequest extends StatelessWidget {
//
//  consultar(uri, body) async{
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    String jsonResponse;
//    if (body) {
//      var response = await http.post(url + uri,
//          headers: {"Content-type": "application/json"},
//          body: jsonEncode(body));
//      if(response.statusCode == 200) {
//        jsonResponse = response.body == "" ? null : json.decode(response.body);
//      }
//    } else {
//      var response = await http
//          .get(url + uri, headers: {"Content-type": "application/json"});
//      if (response.statusCode == 200) {
//        jsonResponse = response.body == "" ? null : json.decode(response.body);
//      }
//    }
//    return null;
//  }
//
//
//  atualizar(uri, body) async {
//    var response = await http.put(url + uri,
//        headers: {"Content-type": "application/json"}, body: jsonEncode(body));
//    if (response.statusCode == 200) {
//      var jsonResponse =
//      response.body == "" ? null : json.decode(response.body);
//      return jsonResponse;
//    }
//    return null;
//  }
//
//  deletar(uri) async {
//    var response = await http
//        .delete(url + uri, headers: {"Content-type": "application/json"});
//    if (response.statusCode == 200) {
//      var jsonResponse =
//      response.body == "" ? null : json.decode(response.body);
//      return jsonResponse;
//    }
//    return null;
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
//
