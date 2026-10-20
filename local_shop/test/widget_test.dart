import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import 'package:local_shop/main.dart';
import 'package:local_shop/perfil_page.dart';

const chaveHistorico = 'local_shop.historico_compras.v1';
const opcoes = SharedPreferencesOptions();

final class ArmazenamentoTeste extends InMemorySharedPreferencesAsync {
  ArmazenamentoTeste() : super.empty();

  bool falharLeitura = false;
  bool falharGravacao = false;
  int gravacoes = 0;
  Completer<void>? gravacaoPendente;

  @override
  Future<String?> getString(String key, SharedPreferencesOptions options) {
    if (falharLeitura) throw StateError('Falha de leitura simulada');
    return super.getString(key, options);
  }

  @override
  Future<bool> setString(
    String key,
    String value,
    SharedPreferencesOptions options,
  ) async {
    gravacoes++;
    if (falharGravacao) throw StateError('Falha de gravação simulada');
    await gravacaoPendente?.future;
    return super.setString(key, value, options);
  }
}

Future<void> iniciarApp(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1200, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(const LocalShopApp());
  await tester.pumpAndSettle();
}

Future<void> adicionar(WidgetTester tester, String nome) async {
  final card = find.ancestor(of: find.text(nome), matching: find.byType(Card));
  await tester.tap(find.descendant(of: card, matching: find.text('Adicionar')));
  await tester.pumpAndSettle();
}

Future<void> navegar(WidgetTester tester, String pagina) async {
  await tester.tap(
    find.byWidgetPredicate(
      (widget) => widget is IconButton && widget.tooltip == pagina,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> finalizar(WidgetTester tester) async {
  await tester.tap(find.text('Finalizar compra'));
  await tester.pumpAndSettle();
}

Finder get comprasNoPerfil => find.descendant(
  of: find.byType(PerfilPage),
  matching: find.byType(ListTile),
);

void main() {
  late ArmazenamentoTeste armazenamento;

  setUp(() {
    armazenamento = ArmazenamentoTeste();
    SharedPreferencesAsyncPlatform.instance = armazenamento;
  });

  testWidgets('carrinho e histórico começam vazios, sem compras fictícias', (
    tester,
  ) async {
    await iniciarApp(tester);
    await navegar(tester, 'Carrinho');
    expect(find.text('Seu carrinho está vazio.'), findsOneWidget);
    expect(find.text('Finalizar compra'), findsNothing);

    await navegar(tester, 'Perfil');
    expect(
      find.text('Você ainda não realizou nenhuma compra.'),
      findsOneWidget,
    );
    expect(comprasNoPerfil, findsNothing);
  });

  testWidgets('finalizar transfere todos os itens, inclusive repetidos', (
    tester,
  ) async {
    await iniciarApp(tester);
    await adicionar(tester, 'Notebook Lenovo');
    await adicionar(tester, 'iPhone 13');
    await adicionar(tester, 'Notebook Lenovo');
    await navegar(tester, 'Carrinho');
    expect(find.text('R\$ 6600,00'), findsOneWidget);

    await finalizar(tester);
    expect(find.text('Seu carrinho está vazio.'), findsOneWidget);
    expect(
      find.byType(Badge).evaluate().every((element) {
        return !(element.widget as Badge).isLabelVisible;
      }),
      isTrue,
    );

    await tester.tap(find.text('Ver histórico'));
    await tester.pumpAndSettle();
    expect(comprasNoPerfil, findsNWidgets(3));
    expect(find.text('Notebook Lenovo'), findsNWidgets(2));
    expect(find.text('iPhone 13'), findsOneWidget);
    expect(find.text('R\$ 1850,00'), findsNWidgets(2));
    expect(find.text('R\$ 2900,00'), findsOneWidget);
    expect(
      find.textContaining(RegExp(r'^\d{2}/\d{2}/\d{4} • Concluída$')),
      findsNWidgets(3),
    );
    expect(armazenamento.gravacoes, 1);
  });

  testWidgets('preserva compras anteriores ao comprar de novo e reabrir', (
    tester,
  ) async {
    await iniciarApp(tester);
    await adicionar(tester, 'Notebook Lenovo');
    await adicionar(tester, 'iPhone 13');
    await navegar(tester, 'Carrinho');
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(ListTile, 'iPhone 13'),
        matching: find.byIcon(Icons.delete_outline),
      ),
    );
    await tester.pumpAndSettle();
    await finalizar(tester);

    await tester.tap(find.widgetWithText(NavigationDestination, 'Ofertas'));
    await tester.pumpAndSettle();
    await adicionar(tester, 'Cadeira Gamer');
    await navegar(tester, 'Carrinho');
    await finalizar(tester);

    // Recria o aplicativo para verificar o carregamento do histórico salvo.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const LocalShopApp());
    await tester.pumpAndSettle();
    await navegar(tester, 'Perfil');

    expect(comprasNoPerfil, findsNWidgets(2));
    final itens = tester.widgetList<ListTile>(comprasNoPerfil).toList();
    expect((itens.first.title as Text).data, 'Cadeira Gamer');
    expect((itens.last.title as Text).data, 'Notebook Lenovo');
    expect(find.text('iPhone 13'), findsNothing);
    expect(armazenamento.gravacoes, 2);
  });

  testWidgets('falha ao salvar mantém os itens e permite tentar novamente', (
    tester,
  ) async {
    await iniciarApp(tester);
    await adicionar(tester, 'Notebook Lenovo');
    await navegar(tester, 'Carrinho');
    armazenamento.falharGravacao = true;
    await finalizar(tester);

    expect(
      find.textContaining('Seus itens continuam no carrinho.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(ListTile, 'Notebook Lenovo'), findsOneWidget);
    expect(await armazenamento.getString(chaveHistorico, opcoes), isNull);

    armazenamento.falharGravacao = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    await navegar(tester, 'Perfil');
    expect(comprasNoPerfil, findsOneWidget);
  });

  testWidgets('bloqueia alterações e finalizações duplicadas enquanto salva', (
    tester,
  ) async {
    await iniciarApp(tester);
    await adicionar(tester, 'Notebook Lenovo');
    await navegar(tester, 'Carrinho');
    armazenamento.gravacaoPendente = Completer<void>();

    final botao = find.widgetWithText(ElevatedButton, 'Finalizar compra');
    final finalizarNovamente = tester.widget<ElevatedButton>(botao).onPressed!;
    await tester.tap(botao);
    await tester.pump();
    finalizarNovamente();
    await tester.pump();

    expect(armazenamento.gravacoes, 1);
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Finalizando compra...'),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<IconButton>(
            find.ancestor(
              of: find.byIcon(Icons.delete_outline),
              matching: find.byType(IconButton),
            ),
          )
          .onPressed,
      isNull,
    );

    armazenamento.gravacaoPendente!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Seu carrinho está vazio.'), findsOneWidget);
    await navegar(tester, 'Perfil');
    expect(comprasNoPerfil, findsOneWidget);
  });

  testWidgets('falha de leitura permite recuperar o histórico anterior', (
    tester,
  ) async {
    await armazenamento.setString(
      chaveHistorico,
      jsonEncode([
        {
          'produto': 'Compra anterior',
          'preco': 'R\$ 100,00',
          'data': '01/10/2026',
          'status': 'Concluída',
        },
      ]),
      opcoes,
    );
    armazenamento.falharLeitura = true;
    await iniciarApp(tester);
    await adicionar(tester, 'Notebook Lenovo');
    await navegar(tester, 'Carrinho');
    expect(find.text('Finalizar compra'), findsNothing);

    await navegar(tester, 'Perfil');
    expect(
      find.text('Não foi possível carregar o histórico de compras.'),
      findsOneWidget,
    );
    armazenamento.falharLeitura = false;
    await tester.ensureVisible(find.text('Tentar novamente'));
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    await navegar(tester, 'Carrinho');
    await finalizar(tester);
    await navegar(tester, 'Perfil');

    expect(comprasNoPerfil, findsNWidgets(2));
    expect(find.text('Compra anterior'), findsOneWidget);
    expect(find.text('Notebook Lenovo'), findsOneWidget);
  });
}
