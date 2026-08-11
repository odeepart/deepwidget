import 'package:deepwidget/features/widget_creator/data/widget_image_repository.dart';
import 'package:deepwidget/features/widget_creator/domain/widget_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<WidgetImageRepository> widgetImageRepositoryProvider =
    Provider<WidgetImageRepository>((ref) {
      return HomeWidgetImageRepository();
    });

final AsyncNotifierProvider<WidgetEditorController, WidgetEditorState>
widgetEditorControllerProvider =
    AsyncNotifierProvider<WidgetEditorController, WidgetEditorState>(
      WidgetEditorController.new,
    );

class WidgetEditorController extends AsyncNotifier<WidgetEditorState> {
  WidgetImageRepository get _repository {
    return ref.read(widgetImageRepositoryProvider);
  }

  @override
  Future<WidgetEditorState> build() async {
    final WidgetImage? image = await _repository.load();
    final int borderRadiusPercent = await _repository.loadBorderRadius();
    try {
      await _repository.refreshWidget();
    } on Object {
      // Ảnh vẫn được lưu bền vững; widget sẽ đọc lại ở lần cập nhật sau.
    }

    bool canPin = false;
    try {
      canPin = await _repository.canPinWidget();
    } on Object {
      // Launcher không hỗ trợ pin vẫn có thể thêm widget thủ công.
    }
    return WidgetEditorState(
      image: image,
      canPinWidget: canPin,
      borderRadiusPercent: borderRadiusPercent,
    );
  }

  void previewBorderRadius(double value) {
    final WidgetEditorState current = state.requireValue;
    state = AsyncData(
      current.copyWith(borderRadiusPercent: value.round(), clearMessage: true),
    );
  }

  Future<void> saveBorderRadius(double value) async {
    final WidgetEditorState current = state.requireValue;
    final int percent = value.round().clamp(0, 50);
    state = AsyncData(
      current.copyWith(
        borderRadiusPercent: percent,
        operation: WidgetEditorOperation.updatingRadius,
        clearMessage: true,
      ),
    );
    try {
      await _repository.saveBorderRadius(percent);
      await _repository.refreshWidget();
      state = AsyncData(
        current.copyWith(
          borderRadiusPercent: percent,
          operation: WidgetEditorOperation.idle,
          message: 'Đã cập nhật bo góc widget: $percent%.',
          messageTone: WidgetEditorMessageTone.success,
        ),
      );
    } on Object {
      state = AsyncData(
        current.copyWith(
          borderRadiusPercent: percent,
          operation: WidgetEditorOperation.idle,
          message: 'Không thể lưu mức bo góc. Hãy thử lại.',
          messageTone: WidgetEditorMessageTone.error,
        ),
      );
    }
  }

  Future<void> chooseImage() async {
    final WidgetEditorState current = state.requireValue;
    state = AsyncData(
      current.copyWith(
        operation: WidgetEditorOperation.choosingImage,
        clearMessage: true,
      ),
    );
    try {
      final WidgetImage? image = await _repository.pickFromGallery();
      if (image == null) {
        state = AsyncData(
          current.copyWith(
            operation: WidgetEditorOperation.idle,
            clearMessage: true,
          ),
        );
        return;
      }

      bool refreshed = true;
      try {
        await _repository.refreshWidget();
      } on Object {
        refreshed = false;
      }
      state = AsyncData(
        current.copyWith(
          image: image,
          operation: WidgetEditorOperation.idle,
          message: refreshed
              ? 'Đã cập nhật ảnh PNG trên widget.'
              : 'Ảnh đã được lưu, nhưng widget chưa thể làm mới. Hãy thử mở lại màn hình chính.',
          messageTone: refreshed
              ? WidgetEditorMessageTone.success
              : WidgetEditorMessageTone.warning,
        ),
      );
    } on Object {
      state = AsyncData(
        current.copyWith(
          operation: WidgetEditorOperation.idle,
          message:
              'Không thể đọc ảnh này. Hãy thử lại với ảnh PNG, JPG hoặc WebP.',
          messageTone: WidgetEditorMessageTone.error,
        ),
      );
    }
  }

  Future<void> pinWidget() async {
    final WidgetEditorState current = state.requireValue;
    if (current.image == null) {
      state = AsyncData(
        current.copyWith(
          message: 'Hãy chọn một ảnh trước khi thêm widget.',
          messageTone: WidgetEditorMessageTone.info,
        ),
      );
      return;
    }
    if (!current.canPinWidget) {
      state = AsyncData(
        current.copyWith(
          message:
              'Launcher này cần thêm thủ công: nhấn giữ màn hình chính, chọn Widget, rồi chọn Deep Widget.',
          messageTone: WidgetEditorMessageTone.info,
        ),
      );
      return;
    }

    state = AsyncData(
      current.copyWith(
        operation: WidgetEditorOperation.pinning,
        clearMessage: true,
      ),
    );
    try {
      await _repository.requestPinWidget();
      state = AsyncData(
        current.copyWith(
          operation: WidgetEditorOperation.idle,
          message: 'Đã gửi yêu cầu thêm Deep Widget ra màn hình chính.',
          messageTone: WidgetEditorMessageTone.success,
        ),
      );
    } on Object {
      state = AsyncData(
        current.copyWith(
          operation: WidgetEditorOperation.idle,
          message:
              'Không thể ghim tự động. Hãy thêm Deep Widget trong danh sách widget của launcher.',
          messageTone: WidgetEditorMessageTone.error,
        ),
      );
    }
  }
}
