class Endereco {
  final String cep;
  final String logradouro;
  final String localidade;
  final String uf;
  final bool erro;

  Endereco({
    required this.cep,
    required this.logradouro,
    required this.localidade,
    required this.uf,
    this.erro = false,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    // A API do ViaCEP retorna "erro": "true" se o CEP não existir (mas o status continua 200)
    if (json.containsKey('erro')) {
      return Endereco(cep: '', logradouro: '', localidade: '', uf: '', erro: true);
    }
    return Endereco(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}