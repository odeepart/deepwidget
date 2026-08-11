import 'package:deepwidget/features/widget_creator/data/widget_image_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel homeWidgetChannel = MethodChannel('home_widget');

  test(
    'removes the legacy bundled image while preserving an empty state',
    () async {
      final Map<String, Object?> widgetData = <String, Object?>{
        HomeWidgetImageRepository.imageKey: '/old/private/widget_image.png',
        HomeWidgetImageRepository.imageNameKey: 'old-demo.png',
        HomeWidgetImageRepository.imageSourceKey:
            HomeWidgetImageRepository.legacyStarterSource,
      };
      final List<String> removedKeys = <String>[];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(homeWidgetChannel, (MethodCall call) async {
            final Map<Object?, Object?> arguments = Map<Object?, Object?>.from(
              call.arguments as Map,
            );
            final String id = arguments['id']! as String;
            switch (call.method) {
              case 'getWidgetData':
                return widgetData[id] ?? arguments['defaultValue'];
              case 'saveWidgetData':
                if (arguments['data'] == null) {
                  removedKeys.add(id);
                  widgetData.remove(id);
                }
                return true;
            }
            throw MissingPluginException(call.method);
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(homeWidgetChannel, null),
      );

      final HomeWidgetImageRepository repository = HomeWidgetImageRepository(
        imagePicker: _NoLostDataImagePicker(),
      );

      expect(await repository.load(), isNull);
      expect(removedKeys.toSet(), <String>{
        HomeWidgetImageRepository.imageKey,
        HomeWidgetImageRepository.imageNameKey,
        HomeWidgetImageRepository.imageSourceKey,
      });
      expect(widgetData, isEmpty);
    },
  );
}

class _NoLostDataImagePicker extends ImagePicker {
  @override
  Future<LostDataResponse> retrieveLostData() async => LostDataResponse.empty();
}
