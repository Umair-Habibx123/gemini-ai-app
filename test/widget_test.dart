import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gemini_ai/main.dart' show parseModelList;
import 'package:gemini_ai/providers/theme_provider.dart';
import 'package:gemini_ai/screens/no_internet_screen.dart';

void main() {
  group('parseModelList', () {
    test('splits, trims and keeps priority order', () {
      expect(parseModelList(' gemini-2.5-flash , gemini-2.0-flash,gemini-2.0-flash-lite '),
          ['gemini-2.5-flash', 'gemini-2.0-flash', 'gemini-2.0-flash-lite']);
    });

    test('drops empty entries and duplicates', () {
      expect(parseModelList('a,,b, ,a'), ['a', 'b']);
    });

    test('falls back to a default when missing or empty', () {
      expect(parseModelList(null), ['gemini-2.0-flash']);
      expect(parseModelList('  ,  '), ['gemini-2.0-flash']);
    });
  });

  group('ThemeProvider', () {
    test('defaults to dark, and restores a saved choice', () async {
      SharedPreferences.setMockInitialValues({});
      final fresh = ThemeProvider();
      await Future<void>.delayed(Duration.zero);
      expect(fresh.mode, ThemeMode.dark);

      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      final saved = ThemeProvider();
      await Future<void>.delayed(Duration.zero);
      expect(saved.mode, ThemeMode.light);
    });

    test('toggle switches mode and saves it', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ThemeProvider();
      await Future<void>.delayed(Duration.zero);
      await provider.toggle();
      expect(provider.mode, ThemeMode.light);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'light');
    });
  });

  testWidgets('offline screen: Try Again calls back, disabled while checking', (tester) async {
    var retries = 0;
    await tester.pumpWidget(MaterialApp(
      home: NoInternetScreen(onRetry: () => retries++, isChecking: false),
    ));
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    expect(retries, 1);

    await tester.pumpWidget(MaterialApp(
      home: NoInternetScreen(onRetry: () => retries++, isChecking: true),
    ));
    expect(find.text('Checking…'), findsOneWidget);
    await tester.tap(find.text('Checking…'));
    expect(retries, 1, reason: 'taps are ignored while a check is running');
  });
}
