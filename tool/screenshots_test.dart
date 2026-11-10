// Generates the README screenshots with the real Roboto font and Material icons.
//
// Run from the project root:
//   flutter test tool/screenshots_test.dart --update-goldens
//
// Kept outside test/ so a normal `flutter test` does not compare these images.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_home_controller/main.dart';
import 'package:smart_home_controller/models/smart_device.dart';

Future<void> _loadFont(String family, List<String> files) async {
  final fontsDir =
      '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
  final loader = FontLoader(family);
  for (final f in files) {
    final bytes = File('$fontsDir/$f').readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

Future<void> _pumpApp(WidgetTester tester) async {
  SmartDevice.resetCounter();
  tester.view.physicalSize = const Size(750, 1624);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const SmartHomeApp());
  await tester.pumpAndSettle();
}

Future<void> _shot(String name) => expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../screenshots/$name.png'),
    );

void main() {
  setUpAll(() async {
    await _loadFont('Roboto', [
      'roboto-regular.ttf',
      'roboto-medium.ttf',
      'roboto-bold.ttf',
    ]);
    await _loadFont('MaterialIcons', ['materialicons-regular.otf']);
  });

  testWidgets('home', (tester) async {
    debugDisableShadows = false;
    await _pumpApp(tester);
    await _shot('home');
    debugDisableShadows = true;
  });

  testWidgets('controls', (tester) async {
    debugDisableShadows = false;
    await _pumpApp(tester);
    await tester.tap(find.byType(Switch).at(1)); // Kitchen light on
    await tester.tap(find.byTooltip('Increase').first); // Bedroom 24 -> 25
    await tester.tap(find.byTooltip('Pause')); // Kitchen speaker paused
    await tester.pumpAndSettle();
    await _shot('controls');
    debugDisableShadows = true;
  });

  testWidgets('details', (tester) async {
    debugDisableShadows = false;
    await _pumpApp(tester);
    await tester.tap(find.text('Smart Light: Living Room'));
    await tester.pumpAndSettle();
    await _shot('details');
    debugDisableShadows = true;
  });

  testWidgets('add_device', (tester) async {
    debugDisableShadows = false;
    await _pumpApp(tester);
    await tester.tap(find.byTooltip('Add device'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Smart Light'));
    await tester.pumpAndSettle();
    await _shot('add_device');
    debugDisableShadows = true;
  });
}
