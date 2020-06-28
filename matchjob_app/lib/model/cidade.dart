import 'package:matchjob/model/estado.dart';

class Cidade {
  int id;
  String nome;
  Estado estado;

  Cidade(this.id, this.nome, this.estado);

  Map toJson() => {
    'id': id,
    'nome': nome,
    'estado':estado,
  };

  Cidade.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        estado = Estado.fromJson(json['estado'])
  ;
}