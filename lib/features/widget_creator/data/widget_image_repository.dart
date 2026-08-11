import 'dart:io';

import 'package:deepwidget/features/widget_creator/domain/widget_image.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

abstract interface class WidgetImageRepository {
  Future<WidgetImage?> load();

  Future<WidgetImage?> pickFromGallery();

  Future<int> loadBorderRadius();

  Future<void> saveBorderRadius(int percent);

  Future<bool> canPinWidget();

  Future<void> requestPinWidget();

  Future<void> refreshWidget();
}

class HomeWidgetImageRepository implements WidgetImageRepository {
  HomeWidgetImageRepository({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  static const String imageKey = 'widget_image';
  static const String imageNameKey = 'widget_image_name';
  static const String imageSourceKey = 'widget_image_source';
  static const String borderRadiusKey = 'widget_border_radius_percent';
  static const int defaultBorderRadius = 12;
  static const String providerClassName =
      'com.odeepart.deepwidget.DeepImageWidgetProvider';
  // Chỉ giữ giá trị cũ để xóa ảnh mẫu đã được cài bởi các bản trước 1.0.2.
  static const String legacyStarterSource = 'starter';
  static const String gallerySource = 'gallery';

  final ImagePicker _imagePicker;

  @override
  Future<WidgetImage?> load() async {
    final WidgetImage? recovered = await _recoverLostSelection();
    if (recovered != null) {
      return recovered;
    }

    final String? source = await HomeWidget.getWidgetData<String>(
      imageSourceKey,
    );
    if (source == legacyStarterSource) {
      await _removeLegacyStarter();
      return null;
    }

    final String? savedPath = await HomeWidget.getWidgetData<String>(imageKey);
    if (savedPath == null || !await File(savedPath).exists()) {
      return null;
    }

    final String displayName =
        await HomeWidget.getWidgetData<String>(
          imageNameKey,
          defaultValue: path.basename(savedPath),
        ) ??
        path.basename(savedPath);
    return WidgetImage(path: savedPath, displayName: displayName);
  }

  @override
  Future<WidgetImage?> pickFromGallery() async {
    final XFile? selected = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    if (selected == null) {
      return null;
    }
    return _saveSelection(selected);
  }

  @override
  Future<int> loadBorderRadius() async {
    final int value =
        await HomeWidget.getWidgetData<int>(
          borderRadiusKey,
          defaultValue: defaultBorderRadius,
        ) ??
        defaultBorderRadius;
    return value.clamp(0, 50);
  }

  @override
  Future<void> saveBorderRadius(int percent) async {
    await HomeWidget.saveWidgetData<int>(borderRadiusKey, percent.clamp(0, 50));
  }

  @override
  Future<bool> canPinWidget() async {
    return await HomeWidget.isRequestPinWidgetSupported() ?? false;
  }

  @override
  Future<void> requestPinWidget() {
    return HomeWidget.requestPinWidget(qualifiedAndroidName: providerClassName);
  }

  @override
  Future<void> refreshWidget() async {
    await HomeWidget.updateWidget(qualifiedAndroidName: providerClassName);
  }

  Future<WidgetImage> _saveSelection(XFile selected) async {
    final File imageFile = File(selected.path);
    if (!await imageFile.exists()) {
      throw StateError('Không tìm thấy tệp ảnh đã chọn.');
    }

    final ImageProvider<Object> imageProvider = ResizeImage(
      FileImage(imageFile),
      width: 1200,
      height: 1200,
      policy: ResizeImagePolicy.fit,
      allowUpscaling: false,
    );
    final String savedPath = await HomeWidget.saveImage(
      imageKey,
      imageProvider,
    );
    // saveImage ghi de cung mot duong dan. Xoa dung ResizeImage cache key ma
    // man preview dung de anh moi khong bi thay bang bitmap cu.
    await ResizeImage(
      FileImage(File(savedPath)),
      width: 1200,
      height: 1200,
      policy: ResizeImagePolicy.fit,
      allowUpscaling: false,
    ).evict();
    final String name = selected.name.trim().isEmpty
        ? path.basename(selected.path)
        : selected.name;
    await _saveMetadata(name: name, source: gallerySource);
    return WidgetImage(path: savedPath, displayName: name);
  }

  Future<void> _saveMetadata({
    required String name,
    required String source,
  }) async {
    await HomeWidget.saveWidgetData<String>(imageNameKey, name);
    await HomeWidget.saveWidgetData<String>(imageSourceKey, source);
  }

  Future<WidgetImage?> _recoverLostSelection() async {
    try {
      final LostDataResponse response = await _imagePicker.retrieveLostData();
      if (response.isEmpty) {
        return null;
      }
      if (response.exception != null) {
        throw response.exception!;
      }
      final List<XFile>? files = response.files;
      final XFile? recovered = files != null && files.isNotEmpty
          ? files.last
          : response.file;
      return recovered == null ? null : _saveSelection(recovered);
    } on UnimplementedError {
      return null;
    }
  }

  Future<void> _removeLegacyStarter() async {
    // home_widget xóa cả tệp do chính plugin quản lý khi giá trị được đặt null.
    await HomeWidget.saveWidgetData<String>(imageKey, null);
    await HomeWidget.saveWidgetData<String>(imageNameKey, null);
    await HomeWidget.saveWidgetData<String>(imageSourceKey, null);
  }
}
