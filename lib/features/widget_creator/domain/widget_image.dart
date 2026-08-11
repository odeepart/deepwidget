import 'package:flutter/foundation.dart';

@immutable
class WidgetImage {
  const WidgetImage({required this.path, required this.displayName});

  final String path;
  final String displayName;

  /// Moi anh duoc chuan hoa thanh PNG truoc khi chuyen sang Android widget.
  bool get isPng => true;

  @override
  bool operator ==(Object other) {
    return other is WidgetImage &&
        other.path == path &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => Object.hash(path, displayName);
}

@immutable
class WidgetEditorState {
  const WidgetEditorState({
    required this.image,
    required this.canPinWidget,
    required this.borderRadiusPercent,
    this.operation = WidgetEditorOperation.idle,
    this.message,
    this.messageTone = WidgetEditorMessageTone.info,
  });

  final WidgetImage? image;
  final bool canPinWidget;
  final int borderRadiusPercent;
  final WidgetEditorOperation operation;
  final String? message;
  final WidgetEditorMessageTone messageTone;

  bool get isWorking => operation != WidgetEditorOperation.idle;

  WidgetEditorState copyWith({
    WidgetImage? image,
    bool? canPinWidget,
    int? borderRadiusPercent,
    WidgetEditorOperation? operation,
    String? message,
    bool clearMessage = false,
    WidgetEditorMessageTone? messageTone,
  }) {
    return WidgetEditorState(
      image: image ?? this.image,
      canPinWidget: canPinWidget ?? this.canPinWidget,
      borderRadiusPercent: borderRadiusPercent ?? this.borderRadiusPercent,
      operation: operation ?? this.operation,
      message: clearMessage ? null : message ?? this.message,
      messageTone: messageTone ?? this.messageTone,
    );
  }
}

enum WidgetEditorOperation { idle, choosingImage, updatingRadius, pinning }

enum WidgetEditorMessageTone { info, success, warning, error }
