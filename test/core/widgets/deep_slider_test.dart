import 'package:deepwidget/core/theme/deep_widget_colors.dart';
import 'package:deepwidget/core/widgets/deep_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the DeepBooth outlined slider geometry', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeepSlider(value: 12, min: 0, max: 50, onChanged: (_) {}),
        ),
      ),
    );

    final SliderTheme sliderTheme = tester.widget<SliderTheme>(
      find.byType(SliderTheme).last,
    );
    final SliderThemeData data = sliderTheme.data;

    expect(data.trackHeight, 3);
    expect(data.trackGap, 15);
    expect(data.activeTrackColor, DeepWidgetColors.primary);
    expect(data.inactiveTrackColor, DeepWidgetColors.glassBorder);
    expect(data.overlayShape!.getPreferredSize(true, false), Size.zero);
    expect(
      data.thumbShape!.getPreferredSize(true, false),
      const Size.square(22),
    );
    expect(tester.getSize(find.byType(DeepSlider)).height, 26);
  });
}
