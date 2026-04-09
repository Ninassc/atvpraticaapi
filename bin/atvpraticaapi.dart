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
  List<Cachorro> dadosFiltrados = [];

  final arquivo = File('./backup_api.json');

  if (arquivo.existsSync()) {
    List<dynamic> dadosExistentes = jsonDecode(arquivo.readAsStringSync());

    for (var dado in dadosExistentes) {
      String id = dado["id"];
      String nome = dado["nome"];
      String descricao = dado["descricao"];
      int vidaMaxima = dado["vidaMaxima"];
      int vidaMinima = dado["vidaMinima"];

      Cachorro c = Cachorro(id, nome, descricao, vidaMaxima, vidaMinima);
      dadosFiltrados.add(c);
    }

  } else {
    try {
      List<dynamic> dados = await pegarApi();

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

      salvarDados(dadosFiltrados);
      //print(dadosFiltrados);
    } catch (erro) {
      print(erro);
    }
  }

  while (true) {
    print("\n");
    stdout.write(
        "Digite:\n1 para LISTAR TUDO\n2 para PESQUISAR\n3 para DELETAR\n4 para SAIR:\n");

    int opcao = int.parse(stdin.readLineSync()!);
    if (opcao == 1) {
      mostrarLista(dadosFiltrados);
    }

    if (opcao == 2) {
      stdout.write("Digite o nome do cachorro que deseja pesquisar: ");
      String nomePesquisa = (stdin.readLineSync()!).toLowerCase();

      final arquivo = File('./backup_api.json');

      List<dynamic> dadosLidos = jsonDecode(arquivo.readAsStringSync());

      //print(dadosLidos);

      for (var dado in dadosLidos) {
        if (dado["nome"].toString().toLowerCase() == nomePesquisa) {
          print("\n");
          print("ID: ${dado["id"]}");
          print("NOME: ${dado["nome"]}");
          print("Descrição: ${dado["descricao"]}");
          print("Vida Máxima: ${dado["vidaMaxima"]}");
          print("Vida Mínima: ${dado["vidaMinima"]}");
          break;
        }
      }
    }

    if (opcao == 3) {
      if (dadosFiltrados.isNotEmpty) {
        stdout.write("Digite um NOME para deletar: ");
        String nomeDeletar = (stdin.readLineSync()!).toLowerCase();
        for (var dado in dadosFiltrados) {
          if (dado.nome.toLowerCase() == nomeDeletar) {
            dadosFiltrados.remove(dado);
            salvarDados(dadosFiltrados);
            print("Cachorro apagado da lista!");
            break;
          }
        }
      }
    }

    if (opcao == 4) {
      print("Saindo...");
      break;
    }
  }

  salvarDados(dadosFiltrados);
}
