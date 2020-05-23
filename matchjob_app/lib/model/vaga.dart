import 'endereco.dart';

class Vaga {
  int id;
  String nome;
  String nomeEmpresa;
  Endereco endereco;
  String descricao;
  String valor;
  String email;
  int idUsuario;

  Vaga(this.id, this.nome, this.descricao, this.valor, this.email,
      this.idUsuario, this.nomeEmpresa, this.endereco);

  Map toJson() =>
      {
        'id': id,
        'nome': nome,
        'nomeEmpresa': nomeEmpresa,
        'endereco': endereco,
        'descricao': descricao,
        'valor': valor,
        'email': email,
        'idUsuario': idUsuario
      };

  Vaga.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        descricao = json['descricao'],
        valor = json['valor'],
        email = json['email'],
        idUsuario = json['idUsuario'],
        nomeEmpresa = json['nomeEmpresa'],
        endereco = Endereco.fromJson(json['endereco']);
}
