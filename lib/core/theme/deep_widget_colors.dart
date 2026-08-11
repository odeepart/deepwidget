import 'package:flutter/material.dart';

/// Nguon mau duy nhat cua giao dien Deep Widget.
///
/// Cac gia tri glass, primary va semantic duoc chuyen truc tiep tu EMODINOT.
/// Widget giao dien khong duoc khai bao [Color] rieng ben ngoai tep nay.
abstract final class DeepWidgetColors {
  static const Color background = Color(0xFF1A1A1A);

  static const Color text = Color(0xFFFFF7F2);
  static const Color textMuted = Color(0xFFC7BAB4);
  static const Color textSoft = Color(0xFFA99892);
  static const Color textDisabled = Color(0xFF756968);
  static const Color textInverse = Color(0xFF1A120F);

  static const Color glassBackground = Color(0x0EFFFFFF);
  static const Color glassBackgroundHover = Color(0x1AFFFFFF);
  static const Color glassBackgroundActive = Color(0x1FFF6D29);
  static const Color glassBorder = Color(0x1FFFFFFF);
  static const Color glassBorderHover = Color(0x52FFFFFF);
  static const Color glassBorderActive = Color(0xFFFF6D29);

  static const Color primary = Color(0xFFFF6D29);
  static const Color primaryHover = Color(0xFFFF895B);
  static const Color primarySoft = Color(0x35685A53);
  static const Color primaryGlow = Color(0x8CFF6D29);
  static const Color activeRing = Color(0x57FF6D29);

  static const Color success = Color(0xFF44D17A);
  static const Color successSoft = Color(0x2E44D17A);
  static const Color successSurface = Color(0xFF173728);
  static const Color warning = Color(0xFFFFC857);
  static const Color warningSoft = Color(0x2EFFC857);
  static const Color danger = Color(0xFFFF6B7A);
  static const Color dangerSoft = Color(0x33FF6B7A);
  static const Color dangerSurface = Color(0xFF482329);

  static const Color disabledSurface = Color(0xD1151515);
  static const Color sliderDisabledTrack = Color(0x5C756968);
  static const Color focusRing = Color(0x9EFF895B);
  static const Color overlay = Color(0x8F000000);
  static const Color shadow = Color(0x61000000);
  static const Color transparent = Color(0x00000000);
  static const Color blurWarmUpSample = Color(0x01000000);

  static const Color checkerLight = Color(0x26FFFFFF);
  static const Color checkerDark = Color(0x14000000);
  static const Color previewSurface = Color(0xFF2A2726);
}
