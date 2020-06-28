import 'cidade.dart';

class Endereco {
  int id;
  Cidade cidade;
  int idCidade;

  Endereco(this.id, this.cidade, this.idCidade);

  Map toJson() => {
    'id': id,
    'cidade': cidade,
    'idCidade': idCidade,
  };

  Endereco.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idCidade = json['idCidade'],
        cidade = Cidade.fromJson(json['cidade'])
  ;
}