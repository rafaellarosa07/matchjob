class Usuario {
  int id;
  String nome;
  String cpfCnpj;
  String tipoPessoa;
  String senha;
  String email;

  Usuario(this.id, this.nome, this.cpfCnpj,this.tipoPessoa,this.email, this.senha);

  Map toJson() => {
    'nome': nome,
    'cpfCnpj': cpfCnpj,
    'tipoPessoa':tipoPessoa,
    'email': email,
    'senha': senha,
  };

  Usuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        cpfCnpj = json['cpfCnpj'],
        tipoPessoa = json['tipoPessoa'],
        email = json['email'];
}