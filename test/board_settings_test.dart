import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shogiground/shogiground.dart';

void main() {
  group('ShogiboardSettings', () {
    test('implements hashCode/==', () {
      expect(const ShogiboardSettings(), const ShogiboardSettings());
      expect(const ShogiboardSettings().hashCode, const ShogiboardSettings().hashCode);

      expect(
        const ShogiboardSettings(),
        isNot(const ShogiboardSettings(colorScheme: ShogiboardColorScheme.brown)),
      );
    });

    test('copyWith', () {
      expect(const ShogiboardSettings().copyWith(), const ShogiboardSettings());

      expect(
        const ShogiboardSettings().copyWith(colorScheme: ShogiboardColorScheme.brown).colorScheme,
        ShogiboardColorScheme.brown,
      );

      expect(
        const ShogiboardSettings(
          border: BoardBorder(color: Color(0xFFFFFFFF), width: 16.0),
        ).copyWith(),
        const ShogiboardSettings(border: BoardBorder(color: Color(0xFFFFFFFF), width: 16.0)),
      );
    });
  });
}
