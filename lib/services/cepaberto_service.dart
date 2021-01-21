import 'dart:io';

import 'package:app_lembrancas_de_amor/models/cepaberto_address.dart';
import 'package:dio/dio.dart';

const token = "811369ac0187209c03457cff15f32277";

class CepAbertoService{

  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    
    final cleanCep = cep.replaceAll(".", "").replaceAll("-", "");
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {

      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if(response.data.isEmpty){
        return Future.error('CEP inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      return address;

    } on DioError catch (e){

      return Future.error('Erro ao buscar CEP');
    }
    
  }

}