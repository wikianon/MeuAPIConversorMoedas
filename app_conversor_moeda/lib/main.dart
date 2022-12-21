import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'components/text_field_item.dart';

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

void main() {
  runApp(const ConversorMoedas()); //runApp
}

class ConversorMoedas extends StatelessWidget {
  const ConversorMoedas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ConversorMoedasHome(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            //Quando inativa borda fica branca
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ), //OutlineInputBorder

            //Quando ativa borda fica amarelada
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
            ), //OutlineInputBorder

            //Simbolo da moeda em verde
            hintStyle: TextStyle(color: Colors.green),
          ) //InputDecorationTheme
          ), //ThemeData
    ); //MaterialApp
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));

  return jsonDecode(response.body);

  //exemplo de acesso:
  //print(jsonDecode(response.body)["results"]["currencies"]["USD"]["buy"]);
}

class ConversorMoedasHome extends StatefulWidget {
  const ConversorMoedasHome({super.key});

  @override
  _ConversorMoedasHomeState createState() => _ConversorMoedasHomeState();
}

class _ConversorMoedasHomeState extends State<ConversorMoedasHome> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();

  late double dolar;
  late double euro;
  late double libra;

  //limpa todos os textos
  void _clearAll() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
    libraController.clear();
  }

  //converte real
  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    libraController.text = (real / libra).toStringAsFixed(2);
  }

  //converte dolar
  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * dolar).toStringAsFixed(2);
    euroController.text = (dolar * dolar / euro).toStringAsFixed(2);
    libraController.text = (dolar * dolar / libra).toStringAsFixed(2);
  }

  //convert euro.
  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * euro).toStringAsFixed(2);
    dolarController.text = (euro * euro / dolar).toStringAsFixed(2);
    libraController.text = (euro * euro / libra).toStringAsFixed(2);
  }

  void _libraChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double libra = double.parse(text);
    realController.text = (libra * libra).toStringAsFixed(2);
    euroController.text = (libra * libra / euro).toStringAsFixed(2);
    dolarController.text = (libra * libra / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                      child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } 
                  else
                  {
                    dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                    libra = snapshot.data!["results"]["currencies"]["GBP"]["buy"];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        //alargando tudo da coluna com stretch
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),

                          //Altura do icone para os campos de conversão..
                          const SizedBox(
                            height: 20,
                          ),

                          TextFieldItem(label: "Reais", prefix: "R\$ ", ctrl: realController, func: _realChanged),

                          //Separando os campos com o Widget Divider
                          const Divider(),
                          TextFieldItem(label: "Dólares", prefix: "U\$\$ ", ctrl: dolarController, func: _dolarChanged),

                          const Divider(),
                          TextFieldItem(label: "Euros", prefix: "€\$\$ ", ctrl: euroController, func: _euroChanged),

                          const Divider(),
                          TextFieldItem(label: "Libras", prefix: "£\$\$ ", ctrl: libraController, func: _libraChanged),

                        ], //<Widget>[]
                      ), //Column
                    ); //SingleChieldScrollView
                  }
              }
            }) //FutureBuilder
        ); //Scaffold
  }
}
