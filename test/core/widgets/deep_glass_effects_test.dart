import 'dart:ui' show SemanticsAction;

import 'package:deepwidget/core/widgets/deep_glass_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pre-renders both blur pipelines then removes warm-up samples', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: DeepBackdropBlurWarmUp(child: SizedBox.expand())),
    );

    expect(find.byKey(DeepBackdropBlurWarmUp.controlWarmUpKey), findsOneWidget);
    expect(find.byKey(DeepBackdropBlurWarmUp.menuWarmUpKey), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 121));
    await tester.pump();

    expect(find.byKey(DeepBackdropBlurWarmUp.controlWarmUpKey), findsNothing);
    expect(find.byKey(DeepBackdropBlurWarmUp.menuWarmUpKey), findsNothing);
  });

  testWidgets('button paints symmetric glow below its active state surface', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeepGlassButton(label: 'Kiểm tra', onPressed: () {}),
        ),
      ),
    );

    final Finder stackFinder = find.descendant(
      of: find.byType(DeepGlassButton),
      matching: find.byType(Stack),
    );
    final Stack stack = tester.widget<Stack>(stackFinder.first);
    expect(stack.clipBehavior, Clip.none);
    expect(stack.children, hasLength(4));
    expect(stack.children[0], isA<ClipRRect>());
    expect(stack.children[1], isA<DeepGlassOuterGlow>());
    expect(stack.children[2], isA<AnimatedContainer>());
    expect(stack.children[3], isA<Material>());
    expect(find.bySemanticsLabel('Kiểm tra'), findsOneWidget);
    expect(
      tester
          .getSemantics(find.bySemanticsLabel('Kiểm tra'))
          .getSemanticsData()
          .hasAction(SemanticsAction.tap),
      isTrue,
    );

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(DeepGlassButton)),
    );
    await tester.pump();

    final DeepGlassOuterGlow glow = tester.widget<DeepGlassOuterGlow>(
      find.descendant(
        of: find.byType(DeepGlassButton),
        matching: find.byType(DeepGlassOuterGlow),
      ),
    );
    expect(glow.visible, isTrue);

    await gesture.up();
    await tester.pumpAndSettle();
  });
}
