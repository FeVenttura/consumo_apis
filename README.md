# 🌐 Consumo de APIs REST com Flutter

Este é um aplicativo desenvolvido em Flutter para demonstrar o consumo de múltiplas APIs REST públicas. O projeto foi construído com foco em boas práticas de arquitetura, serialização de JSON e, principalmente, tratamento robusto de erros de rede (Timeouts, falta de internet e status HTTP inválidos).

O aplicativo atende aos requisitos práticos da disciplina de Desenvolvimento Mobile, explorando requisições HTTP assíncronas e construção de interfaces reativas utilizando o **Material Design 3**.

---

## ✨ Funcionalidades

O projeto consome dois *endpoints* distintos:

1. **Consulta de CEP (ViaCEP):**
   * O usuário digita um CEP de 8 dígitos.
   * O aplicativo consome a API [ViaCEP](https://viacep.com.br/) e preenche automaticamente os campos de Logradouro, Cidade e UF.
   * Validação para garantir que o CEP contenha o tamanho correto antes do envio.

2. **Consulta de Pokémon (PokeAPI):**
   * O usuário digita o nome de um Pokémon.
   * O aplicativo consome a [PokeAPI](https://pokeapi.co/) e retorna a imagem (*sprite*), nome, altura e peso do monstrinho.

---

## 🛡️ Tratamento de Erros e Estabilidade

Uma das prioridades deste projeto é a estabilidade. Todas as requisições estão protegidas por blocos `try-catch` na camada de serviço, cobrindo os seguintes cenários:

* **`SocketException`:** Tratamento para quando o dispositivo do usuário está offline ou em "Modo Avião".
* **`TimeoutException`:** As requisições possuem um limite de 10 segundos (`.timeout(Duration(seconds: 10))`). Caso a API demore a responder, o processo é abortado para evitar que a tela fique travada infinitamente.
* **Validação de Status HTTP:** Tratamento rigoroso de códigos de erro do servidor (como `404 Not Found` caso o usuário busque um Pokémon que não existe, ou erros `500`).
* **Safe Context (`mounted`):** Verificação do ciclo de vida da tela antes de exibir *SnackBars* ou alterar o estado, prevenindo vazamentos de memória e *crashes*.

---

## 🚀 Tecnologias Utilizadas

* **Framework:** [Flutter](https://flutter.dev/)
* **Linguagem:** Dart
* **Pacote de Rede:** [`http`](https://pub.dev/packages/http)
* **UI/UX:** Material Design 3 (Cards, SnackBars flutuantes, inputs arredondados).

---

## 📱 Como executar o projeto

Para rodar este projeto na sua máquina, você precisará ter o Flutter e o Dart instalados. 

1. **Clone este repositório:**
   ```bash
   git clone [https://github.com/FeVenttura/consumo_apis.git]
2. **Acesse a pasta do projeto:**
    ```bash 
    cd consumo_apis
3. **Baixe as dependências (pacote http):**
    ```bash
    flutter pub get
4. **Execute o aplicativo:**
    ```bash
    flutter run 
