class Pokemon {
  final String nome;
  final int altura;
  final int peso;
  final String imagemUrl;

  Pokemon({
    required this.nome,
    required this.altura,
    required this.peso,
    required this.imagemUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      nome: json['name'] ?? '',
      altura: json['height'] ?? 0,
      peso: json['weight'] ?? 0,
      imagemUrl: json['sprites']['front_default'] ?? '',
    );
  }
}