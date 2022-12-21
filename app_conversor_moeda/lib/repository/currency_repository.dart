import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//Chave valida.
//Acesso interno app e servidor
//e12b230d

//Acesso externo
//724247f0

//Chave comprada no dia 20/12/2022
const request = "https://api.hgbrasil.com/finance/quotations?key=e12b230d";
/*
void main()async{
  http.Response response = await http.get(Uri.parse(request));
  //exemplo de acesso:
  print(jsonDecode(response.body)["results"]["currencies"]["USD"]);
  //Saida: {name: Dollar, buy: 5.1974, sell: 5.198, variation: -1.925}
}
*/

class CurrencyRepository {

  Future<Map> getData() async {
    http.Response response = await http.get(Uri.parse(request));

    return jsonDecode(response.body);

    //exemplo de acesso:
    //print(jsonDecode(response.body)["results"]["currencies"]["USD"]["buy"]);
  }
  
}