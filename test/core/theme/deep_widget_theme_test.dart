import 'dart:io';

import 'package:deepwidget/core/theme/deep_widget_colors.dart';
import 'package:deepwidget/core/theme/deep_widget_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Deep Widget color tokens', () {
    test('match the canonical EMODINOT interaction palette', () {
      expect(DeepWidgetColors.background, const Color(0xFF1A1A1A));
      expect(DeepWidgetColors.text, const Color(0xFFFFF7F2));
      expect(DeepWidgetColors.primary, const Color(0xFFFF6D29));
      expect(DeepWidgetColors.glassBackground, const Color(0x0EFFFFFF));
      expect(DeepWidgetColors.glassBackgroundHover, const Color(0x1AFFFFFF));
      expect(DeepWidgetColors.glassBackgroundActive, const Color(0x1FFF6D29));
      expect(DeepWidgetColors.glassBorder, const Color(0x1FFFFFFF));
      expect(DeepWidgetColors.glassBorderHover, const Color(0x52FFFFFF));
      expect(DeepWidgetColors.glassBorderActive, const Color(0xFFFF6D29));
      expect(DeepWidgetColors.primaryGlow, const Color(0x8CFF6D29));
      expect(DeepWidgetColors.activeRing, const Color(0x57FF6D29));
    });
  });

  group('Deep Widget control states', () {
    test('resolve in idle, hover, pressed and disabled order', () {
      expect(
        DeepWidgetTheme.controlBackground(<WidgetState>{}),
        DeepWidgetColors.glassBackground,
      );
      expect(
        DeepWidgetTheme.controlBackground(<WidgetState>{WidgetState.hovered}),
        DeepWidgetColors.glassBackgroundHover,
      );
      expect(
        DeepWidgetTheme.controlBackground(<WidgetState>{WidgetState.pressed}),
        DeepWidgetColors.glassBackgroundActive,
      );
      expect(
        DeepWidgetTheme.controlBackground(<WidgetState>{
          WidgetState.disabled,
          WidgetState.pressed,
        }),
        DeepWidgetColors.disabledSurface,
      );
    });

    test('keeps the 52px target and 220ms transition', () {
      final ButtonStyle style = DeepWidgetTheme.dark().filledButtonTheme.style!;
      expect(
        style.minimumSize!.resolve(<WidgetState>{}),
        const Size(0, DeepWidgetTheme.controlHeight),
      );
      expect(
        style.fixedSize!.resolve(<WidgetState>{}),
        const Size.fromHeight(DeepWidgetTheme.controlHeight),
      );
      expect(style.animationDuration, DeepWidgetTheme.controlDuration);
    });

    test('uses the exact EMODINOT border states without Material shadow', () {
      expect(
        DeepWidgetTheme.controlBorder(<WidgetState>{WidgetState.hovered}),
        const BorderSide(color: DeepWidgetColors.glassBorderHover),
      );
      expect(
        DeepWidgetTheme.controlBorder(<WidgetState>{WidgetState.pressed}),
        const BorderSide(color: DeepWidgetColors.glassBorderActive),
      );
      final ButtonStyle style = DeepWidgetTheme.dark().filledButtonTheme.style!;
      expect(style.elevation!.resolve(<WidgetState>{WidgetState.pressed}), 0);
      expect(
        style.shadowColor!.resolve(<WidgetState>{WidgetState.pressed}),
        DeepWidgetColors.transparent,
      );
    });
  });

  test('uses SamsungOne 12px with 400 body and 700 titles/buttons', () {
    final ThemeData theme = DeepWidgetTheme.dark();
    final List<TextStyle?> bodyStyles = <TextStyle?>[
      theme.textTheme.bodyLarge,
      theme.textTheme.bodyMedium,
      theme.textTheme.bodySmall,
    ];
    final List<TextStyle?> boldStyles = <TextStyle?>[
      theme.textTheme.displayLarge,
      theme.textTheme.headlineLarge,
      theme.textTheme.titleLarge,
      theme.textTheme.labelLarge,
    ];

    for (final TextStyle? style in bodyStyles) {
      expect(style?.fontFamily, DeepWidgetTheme.fontFamily);
      expect(style?.fontSize, 12);
      expect(style?.fontWeight, FontWeight.w400);
    }
    for (final TextStyle? style in boldStyles) {
      expect(style?.fontFamily, DeepWidgetTheme.fontFamily);
      expect(style?.fontSize, 12);
      expect(style?.fontWeight, FontWeight.w700);
    }

    final TextStyle buttonStyle = theme.filledButtonTheme.style!.textStyle!
        .resolve(<WidgetState>{})!;
    expect(buttonStyle.fontFamily, DeepWidgetTheme.fontFamily);
    expect(buttonStyle.fontSize, 12);
    expect(buttonStyle.fontWeight, FontWeight.w700);
  });

  test('Dart UI has one raw color source', () {
    const String allowed = 'lib/core/theme/deep_widget_colors.dart';
    final RegExp rawColor = RegExp(r'\bColor\s*\(');
    final RegExp materialColors = RegExp(r'\bColors\.');
    final List<String> violations = <String>[];

    for (final FileSystemEntity entity in Directory(
      'lib',
    ).listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      final String normalized = entity.path.replaceAll('\\', '/');
      if (normalized == allowed) {
        continue;
      }
      final String source = entity.readAsStringSync();
      if (rawColor.hasMatch(source) || materialColors.hasMatch(source)) {
        violations.add(normalized);
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Move every raw color into $allowed: $violations',
    );
  });
}
