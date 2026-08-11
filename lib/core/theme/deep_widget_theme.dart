import 'package:deepwidget/core/theme/deep_widget_colors.dart';
import 'package:flutter/material.dart';

abstract final class DeepWidgetTheme {
  static const String fontFamily = 'SamsungOne';

  static const double controlRadius = 12;
  static const double panelRadius = 26;
  static const double controlHeight = 52;
  static const double controlBlurSigma = 8;
  static const double menuBlurSigma = 34;
  static const double controlBorderWidth = 1;
  static const Duration controlDuration = Duration(milliseconds: 220);

  static ThemeData dark() {
    final TextTheme textTheme = _buildTextTheme();
    final ButtonStyle glassButtonStyle = _glassButtonStyle();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: DeepWidgetColors.background,
      colorScheme: const ColorScheme.dark(
        primary: DeepWidgetColors.primary,
        onPrimary: DeepWidgetColors.textInverse,
        secondary: DeepWidgetColors.primaryHover,
        onSecondary: DeepWidgetColors.textInverse,
        surface: DeepWidgetColors.background,
        onSurface: DeepWidgetColors.text,
        error: DeepWidgetColors.danger,
        onError: DeepWidgetColors.textInverse,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashFactory: NoSplash.splashFactory,
      focusColor: DeepWidgetColors.glassBackgroundActive,
      hoverColor: DeepWidgetColors.glassBackgroundHover,
      highlightColor: DeepWidgetColors.glassBackgroundActive,
      splashColor: DeepWidgetColors.glassBackgroundActive,
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: DeepWidgetColors.glassBackground,
        surfaceTintColor: DeepWidgetColors.transparent,
        shadowColor: DeepWidgetColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          side: const BorderSide(color: DeepWidgetColors.glassBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: glassButtonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: glassButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: glassButtonStyle),
      textButtonTheme: TextButtonThemeData(style: glassButtonStyle),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: DeepWidgetColors.primary,
        linearTrackColor: DeepWidgetColors.glassBorder,
      ),
      dividerTheme: const DividerThemeData(
        color: DeepWidgetColors.glassBorder,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DeepWidgetColors.background,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: DeepWidgetColors.text,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          side: const BorderSide(color: DeepWidgetColors.glassBorder),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Color controlBackground(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return DeepWidgetColors.disabledSurface;
    }
    if (states.contains(WidgetState.selected) ||
        states.contains(WidgetState.pressed)) {
      return DeepWidgetColors.glassBackgroundActive;
    }
    if (states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused)) {
      return DeepWidgetColors.glassBackgroundHover;
    }
    return DeepWidgetColors.glassBackground;
  }

  static BorderSide controlBorder(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return const BorderSide(
        color: DeepWidgetColors.glassBorder,
        width: controlBorderWidth,
      );
    }
    if (states.contains(WidgetState.selected) ||
        states.contains(WidgetState.pressed)) {
      return const BorderSide(
        color: DeepWidgetColors.glassBorderActive,
        width: controlBorderWidth,
      );
    }
    if (states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused)) {
      return const BorderSide(
        color: DeepWidgetColors.glassBorderHover,
        width: controlBorderWidth,
      );
    }
    return const BorderSide(
      color: DeepWidgetColors.glassBorder,
      width: controlBorderWidth,
    );
  }

  static ButtonStyle _glassButtonStyle() {
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(controlRadius),
    );

    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        return states.contains(WidgetState.disabled)
            ? DeepWidgetColors.textDisabled
            : DeepWidgetColors.text;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        return controlBackground(states);
      }),
      overlayColor: const WidgetStatePropertyAll<Color>(
        DeepWidgetColors.transparent,
      ),
      // DeepGlassButton paints an independent symmetric glow layer. Material
      // elevation would offset that glow toward the bottom edge.
      shadowColor: const WidgetStatePropertyAll<Color>(
        DeepWidgetColors.transparent,
      ),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(
        DeepWidgetColors.transparent,
      ),
      elevation: const WidgetStatePropertyAll<double>(0),
      side: WidgetStateProperty.resolveWith<BorderSide>(controlBorder),
      shape: WidgetStatePropertyAll<OutlinedBorder>(shape),
      minimumSize: const WidgetStatePropertyAll<Size>(Size(0, controlHeight)),
      fixedSize: const WidgetStatePropertyAll<Size>(
        Size.fromHeight(controlHeight),
      ),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 14),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      animationDuration: controlDuration,
      enableFeedback: true,
      textStyle: const WidgetStatePropertyAll<TextStyle>(
        TextStyle(
          inherit: false,
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    TextStyle style(FontWeight weight, {Color? color}) {
      return TextStyle(
        color: color ?? DeepWidgetColors.text,
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: weight,
        letterSpacing: 0,
        height: 1.45,
      );
    }

    return TextTheme(
      displayLarge: style(FontWeight.w700),
      displayMedium: style(FontWeight.w700),
      displaySmall: style(FontWeight.w700),
      headlineLarge: style(FontWeight.w700),
      headlineMedium: style(FontWeight.w700),
      headlineSmall: style(FontWeight.w700),
      titleLarge: style(FontWeight.w700),
      titleMedium: style(FontWeight.w700),
      titleSmall: style(FontWeight.w700),
      bodyLarge: style(FontWeight.w400),
      bodyMedium: style(FontWeight.w400),
      bodySmall: style(FontWeight.w400, color: DeepWidgetColors.textMuted),
      labelLarge: style(FontWeight.w700),
      labelMedium: style(FontWeight.w700),
      labelSmall: style(FontWeight.w700, color: DeepWidgetColors.textMuted),
    );
  }
}
