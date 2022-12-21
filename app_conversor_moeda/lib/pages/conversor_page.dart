import 'package:flutter/material.dart';
import '../components/text_field_item.dart';
import '../repository/currency_repository.dart';

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
            future: CurrencyRepository().getData(),
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

                          TextFieldItem(label: "Reais", prefix: "R\$ ", controller: realController, onChanged: _realChanged),

                          //Separando os campos com o Widget Divider
                          const Divider(),
                          TextFieldItem(label: snapshot.data!["results"]["currencies"]["USD"]["name"], prefix: "U\$\$ ", controller: dolarController, onChanged: _dolarChanged),

                          const Divider(),
                          TextFieldItem(label: snapshot.data!["results"]["currencies"]["EUR"]["name"], prefix: "€\$\$ ", controller: euroController, onChanged: _euroChanged),

                          const Divider(),
                          TextFieldItem(label: snapshot.data!["results"]["currencies"]["GBP"]["name"], prefix: "£\$\$ ", controller: libraController, onChanged: _libraChanged),

                        ], //<Widget>[]
                      ), //Column
                    ); //SingleChieldScrollView
                  }
              }
            }) //FutureBuilder
        ); //Scaffold
  }
}