class Estado {
  int id;
  String nome;
  String uf;

  Estado(this.id, this.nome, this.uf);

  Map toJson() => {
    'id': id,
    'nome': nome,
    'uf':uf,
  };

  Estado.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        uf = json['uf']
  ;
}