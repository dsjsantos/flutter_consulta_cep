import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController txtCep = new TextEditingController();
  String resultado = "";

  _consultaCep() async {
    // Obter cep digitado
    String cep = txtCep.text;

    // Validar cep para consulta
    RegExp regExp = new RegExp(
      r"^[0-9]{8}$",
      caseSensitive: false,
      multiLine: false,
    );
    bool consultar = cep.length == 8;
    consultar = consultar && regExp.hasMatch(cep);

    // Inicializa o resultado
    String mensagem = "";

    if (consultar) {
      // Configurar API URL
      // ignore: unnecessary_brace_in_string_interps
      String url = "https://viacep.com.br/ws/${cep}/json";

      // Criar requisição
      http.Response response;
      response = await http.get(Uri.parse(url));

      try {
        // Dicionário de dados
        Map<String, dynamic> retorno = json.decode(response.body);

        if (!retorno.containsKey("erro")) {
          String logradouro =
              retorno.containsKey("logradouro") ? retorno["logradouro"] : "";
          String localidade =
              retorno.containsKey("localidade") ? retorno["localidade"] : "";
          String uf = retorno.containsKey("uf") ? retorno["uf"] : "";
          String bairro =
              retorno.containsKey("bairro") ? retorno["bairro"] : "";

          mensagem =
              // ignore: unnecessary_brace_in_string_interps
              "Resultado: ${logradouro}, Bairro: ${bairro}, ${localidade}/${uf}";
        } else {
          mensagem = "CEP não encontrado";
        }
      } catch (e) {
        mensagem = "Ocorreu um erro realizando a consulta";
      }
    } else {
      mensagem = "Favor preencher o cep com 8 digitos";
    }

    // Atualizar dados na tela
    setState(() {
      resultado = mensagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultando um CEP via API"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: "Digite um CEP ex: 90540110"),
              style: TextStyle(fontSize: 15),
              controller: txtCep,
            ),
            Text(
              // ignore: unnecessary_brace_in_string_interps
              "${resultado}",
              style: TextStyle(fontSize: 25),
            ),
            ElevatedButton(
              child: Text(
                "Consultar",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: _consultaCep,
            ),
          ],
        ),
      ),
    );
  }
}
