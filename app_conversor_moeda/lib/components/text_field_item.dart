import 'package:flutter/material.dart';

class TextFieldItem extends StatelessWidget {
  const TextFieldItem({
    Key? key,
    required this.label,
    required this.prefix,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final String prefix;
  final TextEditingController controller;
  final Function(String p1) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        border: const OutlineInputBorder(),
        prefixText: prefix,
      ), //InputDecoration

      style: const TextStyle(color: Colors.amber, fontSize: 25.0),

      //Passando uma variavel do tipo função para dentro do onChanged
      //como nossas funçoes de conversão recebe um parametro String na sua declaração
      //ao declararmos uma variavel do tipo função aqui temos que declarar tambem passando argumento String
      //ficando assim: Function(String) onChanged, deste modo a declaração é aceita pelo onChanged
      //Se não fizermos isso a tela não é atualizada ao digitar os valores de conversão sem usar o setState.
      onChanged: onChanged,

      //para receber somente numeros
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}