# Relatório de Tratamento de Erros - Consumo de APIs REST

Este documento detalha as decisões de arquitetura e tratamento de erros aplicadas no aplicativo Flutter que consome as APIs ViaCEP e PokeAPI, cumprindo os requisitos da Aula 15.

## 1. Erros Tratados e sua Importância

Para garantir a estabilidade do aplicativo, foram tratados três cenários principais de falha utilizando blocos `try-catch` e a captura de exceções específicas na camada de serviço (`ApiService`):

* **SocketException (Sem conexão):** Ocorre quando o dispositivo falha em resolver o DNS da API ou não tem rota para a internet. É crucial em aplicações mobile, pois os usuários frequentemente alternam entre redes Wi-Fi, 4G ou entram em zonas de sombra (sem sinal).
* **TimeoutException (Demora na resposta):** Limitamos as requisições a 10 segundos utilizando `.timeout(const Duration(seconds: 10))`. Isso previne que o aplicativo fique com o `CircularProgressIndicator` rodando infinitamente caso o servidor da API esteja sobrecarregado ou a conexão do usuário esteja excessivamente lenta.
* **Status Code diferente de 200 (Erros de Servidor/Cliente):** Tratamos retornos como `404 Not Found` (ex: usuário digitou um nome de Pokémon que não existe) e erros na casa dos `500` (quando a própria API sai do ar). Validar o status HTTP garante que o aplicativo não tente fazer a serialização (`fromJson`) de um HTML de erro, o que causaria um *crash* no sistema.

## 2. Feedback ao Usuário

A comunicação de erros foi centralizada na camada de interface (UI) utilizando o componente `ScaffoldMessenger.of(context).showSnackBar()`. 

* Durante a requisição, a tela bloqueia o botão e exibe um `CircularProgressIndicator`.
* Caso a requisição tenha sucesso, os dados preenchem a tela automaticamente e o *loader* desaparece.
* Caso uma exceção seja lançada (pela falta de internet, timeout ou erro 404), o `catch` na interface exibe uma `SnackBar` vermelha na parte inferior da tela informando o erro em português claro (ex: "Sem conexão com a internet" ou "Pokémon não encontrado"). A tela então volta ao estado inicial, pronta para uma nova tentativa.

## 3. Situações Reais de Ocorrência

* **SocketException:** O usuário está no metrô ou ativou o "Modo Avião" por engano e tenta consultar um CEP. O aplicativo detecta a falta de rede e avisa imediatamente.
* **TimeoutException:** O usuário está no Wi-Fi de um café público com alta latência. O app tenta baixar os dados da PokeAPI, mas após 10 segundos ele cancela a ação para não frustrar o usuário com uma tela "congelada".
* **Status HTTP Inválido:** O usuário tenta buscar o Pokémon "Agumon" (que é de Digimon, não Pokémon). A API retorna status 404, o `ApiService` joga uma exceção e a interface avisa que o monstrinho não foi encontrado, sem quebrar o app.

## 4. O Comportamento Sem o Tratamento

Se este aplicativo fosse publicado sem o bloco `try-catch` e as tratativas do pacote `http`:
1. Se o usuário ficasse sem internet e clicasse em "Buscar", o pacote HTTP jogaria uma exceção fatal não tratada na *thread* principal. Em modo de produção, isso faria o aplicativo fechar abruptamente (crash).
2. Se a API ficasse fora do ar, o app ficaria em uma tela de carregamento eterno, obrigando o usuário a forçar a parada do aplicativo pelas configurações do celular.
3. Se o retorno fosse um erro 404, o Dart tentaria fazer `jsonDecode()` em um corpo vazio ou em uma String HTML, resultando em um `FormatException` ou `TypeError`, quebrando a renderização da tela.