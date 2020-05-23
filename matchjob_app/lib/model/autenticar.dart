class Autenticar {
  String email;
  String senha;


  Autenticar(this.email, this.senha);

  Map toJson() => {
    'email': email,
    'senha': senha,
  };
}