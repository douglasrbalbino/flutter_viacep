import 'dart:convert';

import 'package:flutter_application_3/Models/endereco.dart';
import 'package:http/http.dart' as http;

class ViaCepServices {
  Future<Endereco?> buscarEndereco(String cep) async {
    String endpoint = "https://viacep.com.br/ws/$cep/json/";
    Uri uri = Uri.parse(endpoint);

    var response = await http.get(
      uri,
    ); // O metodo get já devolve no tipo "Response", então aqui estou guardando em uma variavel de nome response do tipo "Response"

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      Endereco endereco = Endereco.fromJson(json);

      return endereco;
    }
  }
}
