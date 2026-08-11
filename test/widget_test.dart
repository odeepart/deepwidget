import 'package:deepwidget/app/app.dart';
import 'package:deepwidget/core/widgets/deep_glass_surface.dart';
import 'package:deepwidget/features/widget_creator/data/widget_image_repository.dart';
import 'package:deepwidget/features/widget_creator/domain/widget_image.dart';
import 'package:deepwidget/features/widget_creator/presentation/widget_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the editor on a small phone and changes image', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final _FakeWidgetImageRepository repository = _FakeWidgetImageRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          widgetImageRepositoryProvider.overrideWithValue(repository),
        ],
        child: const DeepWidgetApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Deep Widget'), findsWidgets);
    expect(find.text('Chưa có ảnh'), findsOneWidget);
    expect(find.text('PNG · ALPHA'), findsNothing);
    expect(find.text('Bo góc widget'), findsOneWidget);
    expect(find.text('12%'), findsOneWidget);
    expect(find.text('Chọn ảnh từ bộ sưu tập'), findsOneWidget);
    expect(find.text('Chọn ảnh trước khi thêm widget'), findsOneWidget);
    expect(find.byType(DeepGlassButton), findsNWidgets(2));
    expect(find.byType(Icon), findsNothing);
    expect(tester.takeException(), isNull);

    final Finder chooseButton = find.text('Chọn ảnh từ bộ sưu tập');
    await tester.ensureVisible(chooseButton);
    await tester.tap(chooseButton);
    await tester.pumpAndSettle();

    expect(repository.pickCount, 1);
    expect(find.text('PNG · ALPHA'), findsOneWidget);
    expect(find.text('Thêm vào màn hình chính'), findsOneWidget);
    expect(find.byType(DeepGlassButton), findsNWidgets(2));
    expect(find.text('Đã cập nhật ảnh PNG trên widget.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeWidgetImageRepository implements WidgetImageRepository {
  WidgetImage? image;

  int pickCount = 0;

  @override
  Future<bool> canPinWidget() async => true;

  @override
  Future<WidgetImage?> load() async => image;

  @override
  Future<int> loadBorderRadius() async => 12;

  @override
  Future<WidgetImage?> pickFromGallery() async {
    pickCount += 1;
    image = const WidgetImage(
      path: 'test/fixtures/missing-gallery.png',
      displayName: 'transparent-logo.png',
    );
    return image;
  }

  @override
  Future<void> refreshWidget() async {}

  @override
  Future<void> requestPinWidget() async {}

  @override
  Future<void> saveBorderRadius(int percent) async {}
}
