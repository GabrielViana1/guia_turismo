import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:guia/main.dart';

void main() {
  testWidgets('Inicializar monta o app', (WidgetTester tester) async {
    await tester.pumpWidget(const Inicializar());

    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
