import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:md/main.dart';

void main() {
  testWidgets('AppTest', (WidgetTester tester) async {
    //Dashboard
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.enterText(find.byType(TextFormField), '@#\$');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.enterText(find.byType(TextFormField), 'Matemática-Avançada');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.enterText(find.byType(TextFormField), 'Mate');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.enterText(find.byType(TextFormField), 'Física Quântica');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.enterText(find.byType(TextFormField), '');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.ensureVisible(find.text('Lógica'));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('Lógica'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.ensureVisible(find.text('Lógica'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lógica'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    //Cadastro de curso
    await salvar(tester);
    await input('completo', 'Desenvolvimento de Aplicativos Móveis', tester);
    await salvar(tester);
    await input('breve', 'Mobile', tester);
    await salvar(tester);

    await tester.ensureVisible(find.byKey(Key('categoria')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('categoria')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Qualidade de Software'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await salvar(tester);

    await tester.ensureVisible(find.byKey(Key('inicio')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('inicio')));
    await tester.pumpAndSettle();
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));
    await salvar(tester);

    await tester.ensureVisible(find.byKey(Key('inicio')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('inicio')));
    await tester.pumpAndSettle();
    for (int i = 0; i < 4; i++) {
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    //

    await tester.ensureVisible(find.byKey(Key('fim')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('fim')));
    await tester.pumpAndSettle();
    for (int i = 0; i < 3; i++) {
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));
    await salvar(tester);

    //
    await tester.ensureVisible(find.byKey(Key('fim')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('fim')));
    await tester.pumpAndSettle();
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await salvar(tester);

    await tester.tap(find.byIcon(Icons.add_box_outlined));
    await tester.pumpAndSettle();

    for (int i = 0; i < 6; i++) {
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();
    }
    await tester.pump(const Duration(seconds: 10));

    for (int i = 0; i < 2; i++) {
      await tester.tap(find.byIcon(Icons.remove).last);
      await tester.pumpAndSettle();
    }
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    await salvar(tester);

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await salvar(tester);
    await input('nome', 'Robson Denner', tester);
    await input('email', 'robson.denneremailcom', tester);
    await input('email', 'robson.denner@email.com', tester);
    await salvar(tester);

    await tester.tap(find.byIcon(Icons.edit_document));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.ensureVisible(find.text('Gerar Relatório'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gerar Relatório'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.ensureVisible(find.byIcon(Icons.search).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.search).first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    for (int i = 0; i < 3; i++) {
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 10));
    }

    await tester.tap(find.byIcon(Icons.remove).last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.text('Fechar').last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    //

    await tester.ensureVisible(find.byIcon(Icons.search).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.search).last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    for (int i = 0; i < 2; i++) {
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 10));
    }

    await tester.tap(find.byIcon(Icons.remove).last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.text('Fechar').last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.ensureVisible(find.text('Gerar Relatório'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gerar Relatório'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));
  });
}

salvar(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Salvar'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Salvar'));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 10));
}

input(String key, String value, WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(Key(key)));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(Key(key)), value);
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 10));
}
