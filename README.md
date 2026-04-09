# RELATÓRIO FINAL

1)  Foi usada a API The Dog API (v2).
    Documentação: https://dogapi.dog/docs/api-v2

2) A lista não vinha solta logo no começo. Ela estava guardada dentro da chave `"data"`. Da mesma forma, precisei entrar em objetos dentro de outros objetos para extrair os dados restantes. O nome e a descrição do cão estavam dentro da chave `"attributes"`. Já o tempo de vida máximo e mínimo ficavam ainda mais escondidos: dentro de `"attributes"` e na chave `"life"`.

3) O programa busca o cachorro pelo nome na lista principal do código (`dadosFiltrados`) e usa o comando `.remove()` para tirá-lo da memória. Depois, ele chama a função de salvar, reescrevendo o arquivo `backup_api.json`, mas com a lista atualizada sem o cachorro apagado.

4) Não, ele não volta. Isso acontece pois logo que o programa inicia ele verifica se o arquivo `backup_api.json` já existe no pc. Como o arquivo já existe, o código ignora pegar a API e passa a preencher as informações do menu lendo apenas os dados salvos nesse arquivo.
