import 'package:atvpraticaapi/atvpraticaapi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void salvarDados(List<Cachorro> listaDados) {
  final arquivo = File('./backup_api.json');

  List<Map<String, dynamic>> listaSalvos =
      listaDados.map((dados) => dados.toJson()).toList();

  arquivo.writeAsStringSync(jsonEncode(listaSalvos));
}

void mostrarLista(List<Cachorro> dadosFiltrados) {
  for (var dado in dadosFiltrados) {
    print("\n");
    print("ID: ${dado.id}");
    print("NOME: ${dado.nome}");
    print("Descrição: ${dado.descricao}");
    print("Vida Máxima: ${dado.vidaMaxima}");
    print("Vida Mínima: ${dado.vidaMinima}");
  }
}

Future<List<dynamic>> pegarApi() async {
  final url = Uri.parse("https://dogapi.dog/api/v2/breeds");

  final resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    Map<String, dynamic> corpo = jsonDecode(resposta.body);
    //print(corpo);

    //print(corpo["data"][0]);

    return corpo['data'];
  } else {
    throw Exception("Erro --> Código: ${resposta.statusCode}");
  }
}

Future<void> main(List<String> arguments) async {
  stdout.write(
      "Digite:\n1 para LISTAR TUDO\n2 para PESQUISAR\n3 para DELETAR\n4 para SAIR:\n");

  int opcao = int.parse(stdin.readLineSync()!);

  while (opcao != 4) {
    if (opcao == 1) {
      try {
        List<dynamic> dados = await pegarApi();

        List<Cachorro> dadosFiltrados = [];

        for (var dado in dados) {
          String id = dado["id"];
          //print(id);

          String nome = dado["attributes"]["name"];
          //print(nome);

          String descricao = dado["attributes"]["description"];
          //print(descricao);

          int vidaMaxima = dado["attributes"]["life"]["max"];
          int vidaMinima = dado["attributes"]["life"]["min"];

          Cachorro c = Cachorro(id, nome, descricao, vidaMaxima, vidaMinima);

          dadosFiltrados.add(c);
        }

        //print(dadosFiltrados);

        salvarDados(dadosFiltrados);
        mostrarLista(dadosFiltrados);
      } catch (erro) {
        print(erro);
      }
    }
  }
}
