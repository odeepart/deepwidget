import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not bundle a starter image or expose private widget data', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final String widgetInfo = File(
      'android/app/src/main/res/xml/deep_image_widget_info.xml',
    ).readAsStringSync();
    final String gradle = File(
      'android/app/build.gradle.kts',
    ).readAsStringSync();

    expect(pubspec, isNot(contains('starter_widget.png')));
    expect(File('assets/images/starter_widget.png').existsSync(), isFalse);
    expect(
      File(
        'android/app/src/main/res/drawable-nodpi/deep_widget_preview.png',
      ).existsSync(),
      isFalse,
    );
    expect(widgetInfo, isNot(contains('deep_widget_preview')));

    expect(manifest, contains('android:allowBackup="false"'));
    expect(manifest, contains('android:usesCleartextTraffic="false"'));
    expect(manifest, contains('android:dataExtractionRules='));
    expect(manifest, contains('android:fullBackupContent='));
    expect(manifest, isNot(contains('READ_EXTERNAL_STORAGE')));
    expect(manifest, isNot(contains('READ_MEDIA_IMAGES')));
    expect(manifest, isNot(contains('android.permission.INTERNET')));
    expect(
      manifest,
      contains(
        'android:name=".DeepImageWidgetProvider"\n            android:exported="false"',
      ),
    );
    expect(gradle, isNot(contains('signingConfigs.getByName("debug")')));
  });
}
