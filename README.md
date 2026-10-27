# ProntoFix · App Flutter

App do ProntoFix feita com o design da página **"Mockups ProntoFix — Pro"**
do Figma e com a matéria das aulas de Programação de Dispositivos Móveis
(prof. João Monge). Os ecrãs usam só o que foi dado nas aulas; os pacotes
externos aparecem apenas onde o projeto os exige (mapa, GPS, câmara, QR,
chamadas e API REST) e ficam isolados em `servicos/` e `widgets/mapa.dart`.

## Como executar

```bash
cd app
flutter create . --org pt.iade --project-name prontofix --platforms android,ios
dart run tool/configurar_plataformas.dart   # permissões: internet, GPS, câmara
flutter pub get
flutter run
```

O `flutter create .` só gera as pastas `android/` e `ios/`; não mexe em
`lib/` nem em `test/`. Testes: `flutter test`.

## Ecrãs

| Mockup | Ficheiro |
|---|---|
| 01 Splash | `lib/ecras/splash_page.dart` |
| 02 Login | `lib/ecras/login_page.dart` |
| Criar conta | `lib/ecras/registo_page.dart` |
| 03 Home Cliente | `lib/ecras/cliente/home_page.dart` |
| 04 Criar pedido | `lib/ecras/cliente/criar_pedido_page.dart` |
| 05 Confirmar localização | `lib/ecras/cliente/confirmar_localizacao_page.dart` |
| 06 Prestador a caminho | `lib/ecras/cliente/acompanhamento_page.dart` |
| 07 Finalizar serviço | `lib/ecras/cliente/finalizar_servico_page.dart` |
| Ler QR de chegada | `lib/ecras/cliente/ler_qr_page.dart` |
| Os meus pedidos + detalhe (favorito, repetir) | `lib/ecras/cliente/pedidos_page.dart` |
| Mapa | `lib/ecras/cliente/mapa_page.dart` |
| 08 Área do prestador | `lib/ecras/prestador/area_prestador_page.dart` |
| Serviço atual (prestador) | `lib/ecras/prestador/servico_page.dart` |
| Serviços do prestador | `lib/ecras/prestador/servicos_feitos_page.dart` |
| Perfil | `lib/ecras/perfil_page.dart` |

Outras pastas: `modelos/` (classes `Categoria` e `Pedido`, com JSON),
`dados/` (dados fictícios e estimativas), `servicos/` (API REST, GPS,
chamadas), `widgets/` (widgets reutilizáveis e mapa) e `tema/` (cores).

## Requisitos do projeto cobertos

| Requisito | Onde |
|---|---|
| RF01 Registo e login (cliente/prestador) | `login_page.dart`, `registo_page.dart` |
| RF02 Pedido com categoria, descrição e foto | `criar_pedido_page.dart` (câmara/galeria) |
| RF03 Localização por GPS e confirmar morada | `confirmar_localizacao_page.dart` + `servicos/localizacao.dart` |
| RF04 Estimativa de preço e chegada | `dados_ficticios.dart` (`estimarPreco`, `estimarChegada`) |
| RF05/RF06 Notificação e prestador no mapa | `acompanhamento_page.dart` + `widgets/mapa.dart` |
| RF07 Chegada por QR Code | prestador mostra (`servico_page.dart`), cliente lê (`ler_qr_page.dart`) |
| RF08 Pagamento simulado e avaliação | `finalizar_servico_page.dart` |
| Cancelar antes de o prestador sair | `acompanhamento_page.dart` |
| Histórico, favoritos e repetir pedido | `pedidos_page.dart` |
| Prestador: disponível, aceitar/recusar com 30 s, rota, valor final | `prestador/` |
| API REST (Node.js) | `servicos/api.dart` |

## Onde está cada matéria das aulas

- **Posicionamento** (Aula 03/04, Fichas 01 e 02): `Row`, `Column`,
  `Expanded`, `Padding`, `Container` com `BoxDecoration`, `Stack` +
  `Positioned` nos círculos do Splash e nas etiquetas por cima do mapa.
- **Stateless / Stateful** (Aula 05/06, Ficha 03): as páginas que mudam
  usam `setState()` (escolha de categoria e urgência, estrelas, interruptor
  "Disponível agora"). Em `acompanhamento_page.dart` um `Timer` simula o
  servidor e atualiza o estado a cada 3 segundos.
- **Formulários** (Aula 07/08): login e registo com `Form`,
  `GlobalKey<FormState>`, `TextFormField` + `validator`,
  `TextEditingController` libertado em `dispose()`,
  `DropdownButtonFormField`, `SwitchListTile` e `CheckboxListTile`.
  O valor final do serviço também é um pequeno formulário validado.
- **Navegação** (Aula 09/10): rotas nomeadas em `main.dart`,
  `Navigator.push` / `pop`, dados enviados pelo construtor e respostas
  devolvidas no `pop` (o "Criar pedido" devolve o `Pedido` criado; o
  acompanhamento devolve `true` quando o pedido foi pago), e
  `BottomNavigationBar` nas áreas do cliente e do prestador.
- **Listas** (Aula 11/12): `ListView.builder` no histórico de pedidos,
  `GridView.builder` no resumo do prestador e widgets reutilizáveis
  (`CategoriaCard`, `PedidoCard`) criados a partir de objetos, como o
  `CursoCard` da aula.

## Demonstração

**Cliente:** "Já tenho conta" → qualquer email válido e palavra-passe com
6+ caracteres → Entrar. Tocar numa categoria ou em "Começar pedido",
descrever o problema → Continuar → Confirmar pedido. O prestador aceita e
aproxima-se no mapa; quando chegar, "Ler QR de chegada" (no emulador,
"Demonstração: simular leitura"). Pode cancelar-se antes de o prestador sair.
No fim: Pagar e avaliar.

**Prestador:** escolher "Prestador" no login → ligar "Disponível agora".
Em 3 segundos chega um pedido com 30 s para responder → Aceitar →
Iniciar viagem (botão "Rota" abre o Google Maps) → Cheguei • mostrar QR →
Concluir serviço (mão de obra, material e o que foi feito).

## Ligar ao servidor

Em `lib/servicos/api.dart`, pôr `usarDadosFicticios = false` e confirmar
`enderecoServidor`. Os endpoints seguem a tabela do README principal
(`/auth/login`, `/pedidos`, `/pedidos/:id/estado`, `/pedidos/:id/chegada`,
`/pedidos/:id/avaliacao`, `/prestadores/:id/disponibilidade`...). O
acompanhamento passa a perguntar o estado ao servidor a cada 3 segundos.

## Próximos passos

- Notificações push (Firebase).
- Chat dentro da app (por agora "Mensagem" abre o SMS).
