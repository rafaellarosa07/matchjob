class Endereco {
  int id;
  String cep;
  String longitude;
  String latitude;

  Endereco(this.id, this.cep, this.longitude,this.latitude);

  Map toJson() => {
    'id': id,
    'cep': cep,
    'longitude':longitude,
    'latitude': latitude,
  };

  Endereco.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cep = json['cep'],
        longitude = json['longitude'],
        latitude = json['latitude'];
}