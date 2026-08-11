import 'package:deepwidget/core/theme/deep_widget_colors.dart';
import 'package:flutter/material.dart';

/// Slider dùng cùng hình học với slider hiệu chỉnh của DeepBooth.
class DeepSlider extends StatelessWidget {
  const DeepSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.onChangeEnd,
    this.semanticFormatterCallback,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
  final SemanticFormatterCallback? semanticFormatterCallback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackShape: const _DeepInsetSliderTrackShape(),
          trackHeight: 3,
          trackGap: 15,
          activeTrackColor: DeepWidgetColors.primary,
          inactiveTrackColor: DeepWidgetColors.glassBorder,
          disabledActiveTrackColor: DeepWidgetColors.sliderDisabledTrack,
          disabledInactiveTrackColor: DeepWidgetColors.glassBorder,
          thumbColor: DeepWidgetColors.primary,
          disabledThumbColor: DeepWidgetColors.textDisabled,
          thumbShape: const _DeepOutlinedSliderThumbShape(),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
          showValueIndicator: ShowValueIndicator.never,
        ),
        child: Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
          semanticFormatterCallback: semanticFormatterCallback,
        ),
      ),
    );
  }
}

class _DeepInsetSliderTrackShape extends GappedSliderTrackShape {
  const _DeepInsetSliderTrackShape();

  static const double _horizontalInset = 11;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 3;
    final double trackLeft = offset.dx + _horizontalInset;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - (_horizontalInset * 2);
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class _DeepOutlinedSliderThumbShape extends SliderComponentShape {
  const _DeepOutlinedSliderThumbShape();

  static const double _radius = 11;
  static const double _borderWidth = 3;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(_radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Color borderColor = Color.lerp(
      DeepWidgetColors.textDisabled,
      DeepWidgetColors.primary,
      enableAnimation.value,
    )!;
    context.canvas.drawCircle(
      center,
      _radius - (_borderWidth / 2),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth,
    );
  }
}
