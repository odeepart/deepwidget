import 'package:deepwidget/features/widget_creator/data/widget_image_repository.dart';
import 'package:deepwidget/features/widget_creator/domain/widget_image.dart';
import 'package:deepwidget/features/widget_creator/presentation/widget_editor_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starts empty, changes image and requests pin', () async {
    final _FakeRepository repository = _FakeRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: [widgetImageRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final WidgetEditorState initial = await container.read(
      widgetEditorControllerProvider.future,
    );
    expect(initial.image, isNull);
    expect(initial.canPinWidget, isTrue);
    expect(initial.borderRadiusPercent, 12);

    await container.read(widgetEditorControllerProvider.notifier).chooseImage();
    final WidgetEditorState changed = container
        .read(widgetEditorControllerProvider)
        .requireValue;
    expect(changed.image?.displayName, 'gallery.png');
    expect(changed.message, 'Đã cập nhật ảnh PNG trên widget.');

    await container.read(widgetEditorControllerProvider.notifier).pinWidget();
    expect(repository.pinCount, 1);
    expect(
      container.read(widgetEditorControllerProvider).requireValue.message,
      'Đã gửi yêu cầu thêm Deep Widget ra màn hình chính.',
    );

    final WidgetEditorController controller = container.read(
      widgetEditorControllerProvider.notifier,
    );
    controller.previewBorderRadius(28);
    expect(
      container
          .read(widgetEditorControllerProvider)
          .requireValue
          .borderRadiusPercent,
      28,
    );
    await controller.saveBorderRadius(28);
    expect(repository.savedBorderRadius, 28);
  });

  test('keeps the selected image when widget refresh fails', () async {
    final _FakeRepository repository = _FakeRepository()
      ..refreshShouldFail = true;
    final ProviderContainer container = ProviderContainer(
      overrides: [widgetImageRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(widgetEditorControllerProvider.future);
    await container.read(widgetEditorControllerProvider.notifier).chooseImage();

    final WidgetEditorState changed = container
        .read(widgetEditorControllerProvider)
        .requireValue;
    expect(changed.image?.displayName, 'gallery.png');
    expect(changed.messageTone, WidgetEditorMessageTone.warning);
    expect(changed.message, contains('Ảnh đã được lưu'));
  });
}

class _FakeRepository implements WidgetImageRepository {
  int pinCount = 0;
  bool refreshShouldFail = false;
  int savedBorderRadius = 12;

  @override
  Future<bool> canPinWidget() async => true;

  @override
  Future<WidgetImage?> load() async => null;

  @override
  Future<int> loadBorderRadius() async => savedBorderRadius;

  @override
  Future<WidgetImage?> pickFromGallery() async {
    return const WidgetImage(path: 'gallery.png', displayName: 'gallery.png');
  }

  @override
  Future<void> refreshWidget() async {
    if (refreshShouldFail) {
      throw StateError('refresh failed');
    }
  }

  @override
  Future<void> requestPinWidget() async {
    pinCount += 1;
  }

  @override
  Future<void> saveBorderRadius(int percent) async {
    savedBorderRadius = percent;
  }
}
