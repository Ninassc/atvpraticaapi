class Cachorro {
  String id = '';
  String nome = "";
  String descricao = "";
  int vidaMaxima = 0;
  int vidaMinima = 0;

  Cachorro(
      this.id, this.nome, this.descricao, this.vidaMaxima, this.vidaMinima);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "descricao": descricao,
      "vidaMaxima": vidaMaxima,
      "vidaMinina": vidaMinima
    };

  }
}
