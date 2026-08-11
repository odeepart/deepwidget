import 'dart:io';

import 'package:deepwidget/core/theme/deep_widget_colors.dart';
import 'package:deepwidget/core/theme/deep_widget_theme.dart';
import 'package:deepwidget/core/widgets/deep_glass_surface.dart';
import 'package:deepwidget/core/widgets/deep_slider.dart';
import 'package:deepwidget/core/widgets/deep_widget_backdrop.dart';
import 'package:deepwidget/features/widget_creator/domain/widget_image.dart';
import 'package:deepwidget/features/widget_creator/presentation/widget_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetEditorPage extends ConsumerWidget {
  const WidgetEditorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<WidgetEditorState> editor = ref.watch(
      widgetEditorControllerProvider,
    );

    return Scaffold(
      body: DeepWidgetBackdrop(
        child: SafeArea(
          child: editor.when(
            data: (state) => _EditorContent(state: state),
            loading: () => const _LoadingView(),
            error: (_, _) => _ErrorView(
              onRetry: () => ref.invalidate(widgetEditorControllerProvider),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditorContent extends ConsumerWidget {
  const _EditorContent({required this.state});

  final WidgetEditorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WidgetEditorController controller = ref.read(
      widgetEditorControllerProvider.notifier,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double horizontalPadding = constraints.maxWidth < 420 ? 16 : 24;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            36,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _AppHeader(),
                  const SizedBox(height: 24),
                  if (state.image case final WidgetImage image)
                    _WidgetPreview(
                      image: image,
                      borderRadiusPercent: state.borderRadiusPercent,
                    )
                  else
                    const _EmptyPreview(),
                  const SizedBox(height: 18),
                  _ActionSection(
                    state: state,
                    onChooseImage: state.isWorking
                        ? null
                        : controller.chooseImage,
                    onRadiusChanged: state.isWorking
                        ? null
                        : controller.previewBorderRadius,
                    onRadiusChangeEnd: state.isWorking
                        ? null
                        : controller.saveBorderRadius,
                    onPinWidget: state.isWorking || state.image == null
                        ? null
                        : controller.pinWidget,
                  ),
                  if (state.message != null) ...<Widget>[
                    const SizedBox(height: 12),
                    _MessageBanner(
                      message: state.message!,
                      tone: state.messageTone,
                    ),
                  ],
                  const SizedBox(height: 24),
                  const _HowItWorks(),
                  const SizedBox(height: 16),
                  const _PrivacyNote(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Deep Widget', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 3),
        Text(
          'Đưa ảnh yêu thích lên màn hình chính, giữ nguyên vùng PNG trong suốt.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: DeepWidgetColors.textMuted),
        ),
      ],
    );
  }
}

class _WidgetPreview extends StatelessWidget {
  const _WidgetPreview({
    required this.image,
    required this.borderRadiusPercent,
  });

  final WidgetImage image;
  final int borderRadiusPercent;

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object> provider = ResizeImage(
      FileImage(File(image.path)),
      width: 1200,
      height: 1200,
      policy: ResizeImagePolicy.fit,
      allowUpscaling: false,
    );

    return DeepGlassSurface(
      active: true,
      hoverEffects: true,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(DeepWidgetTheme.panelRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text('Ảnh widget', style: Theme.of(context).textTheme.titleLarge),
              const _StatusPill(),
            ],
          ),
          const SizedBox(height: 14),
          AspectRatio(
            aspectRatio: 1,
            child: Semantics(
              image: true,
              label: 'Xem trước ảnh widget ${image.displayName}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    const ColoredBox(color: DeepWidgetColors.previewSurface),
                    const CustomPaint(painter: _TransparencyPainter()),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double shortestSide =
                              constraints.maxWidth < constraints.maxHeight
                              ? constraints.maxWidth
                              : constraints.maxHeight;
                          final double radius =
                              shortestSide * borderRadiusPercent / 100;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: Image(
                              key: ObjectKey(image),
                              image: provider,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              gaplessPlayback: true,
                              excludeFromSemantics: true,
                              errorBuilder: (_, _, _) => const _BrokenImage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vùng caro là phần trong suốt; hình nền màn hình chính sẽ xuyên qua tại đây.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            image.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: DeepWidgetColors.textSoft),
          ),
        ],
      ),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview();

  @override
  Widget build(BuildContext context) {
    return DeepGlassSurface(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(DeepWidgetTheme.panelRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Chưa có ảnh', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Deep Widget không kèm ảnh mẫu. Chọn ảnh từ bộ sưu tập để bắt đầu.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DeepWidgetColors.successSoft,
        border: Border.all(color: DeepWidgetColors.success),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'PNG · ALPHA',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: DeepWidgetColors.text),
        ),
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.state,
    required this.onChooseImage,
    required this.onRadiusChanged,
    required this.onRadiusChangeEnd,
    required this.onPinWidget,
  });

  final WidgetEditorState state;
  final VoidCallback? onChooseImage;
  final ValueChanged<double>? onRadiusChanged;
  final ValueChanged<double>? onRadiusChangeEnd;
  final VoidCallback? onPinWidget;

  @override
  Widget build(BuildContext context) {
    return DeepGlassSurface(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(DeepWidgetTheme.panelRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Thiết lập nhanh',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Bo góc widget',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                '${state.borderRadiusPercent}%',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: DeepWidgetColors.primary,
                ),
              ),
            ],
          ),
          DeepSlider(
            value: state.borderRadiusPercent.toDouble(),
            min: 0,
            max: 50,
            onChanged: onRadiusChanged,
            onChangeEnd: onRadiusChangeEnd,
            semanticFormatterCallback: (value) => '${value.round()} phần trăm',
          ),
          Text(
            '0% là góc vuông, 50% là bo tròn tối đa.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final Widget chooseButton = _GlassButton(
                onPressed: onChooseImage,
                label: state.operation == WidgetEditorOperation.choosingImage
                    ? 'Đang mở bộ sưu tập…'
                    : 'Chọn ảnh từ bộ sưu tập',
              );
              final Widget pinButton = _GlassButton(
                onPressed: onPinWidget,
                label: state.image == null
                    ? 'Chọn ảnh trước khi thêm widget'
                    : state.operation == WidgetEditorOperation.pinning
                    ? 'Đang thêm widget…'
                    : state.canPinWidget
                    ? 'Thêm vào màn hình chính'
                    : 'Xem cách thêm widget',
              );

              if (constraints.maxWidth >= 520) {
                return Row(
                  children: <Widget>[
                    Expanded(child: chooseButton),
                    const SizedBox(width: 10),
                    Expanded(child: pinButton),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  chooseButton,
                  const SizedBox(height: 10),
                  pinButton,
                ],
              );
            },
          ),
          if (!state.canPinWidget) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              'Nếu launcher không hỗ trợ ghim nhanh: nhấn giữ màn hình chính → Widget → Deep Widget.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.message, required this.tone});

  final String message;
  final WidgetEditorMessageTone tone;

  @override
  Widget build(BuildContext context) {
    final Color accent = switch (tone) {
      WidgetEditorMessageTone.info => DeepWidgetColors.primary,
      WidgetEditorMessageTone.success => DeepWidgetColors.success,
      WidgetEditorMessageTone.warning => DeepWidgetColors.warning,
      WidgetEditorMessageTone.error => DeepWidgetColors.danger,
    };
    final Color background = switch (tone) {
      WidgetEditorMessageTone.info => DeepWidgetColors.primarySoft,
      WidgetEditorMessageTone.success => DeepWidgetColors.successSoft,
      WidgetEditorMessageTone.warning => DeepWidgetColors.warningSoft,
      WidgetEditorMessageTone.error => DeepWidgetColors.dangerSoft,
    };
    final String toneLabel = switch (tone) {
      WidgetEditorMessageTone.info => 'THÔNG TIN',
      WidgetEditorMessageTone.success => 'THÀNH CÔNG',
      WidgetEditorMessageTone.warning => 'LƯU Ý',
      WidgetEditorMessageTone.error => 'LỖI',
    };
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: accent),
          borderRadius: BorderRadius.circular(DeepWidgetTheme.controlRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                toneLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(message, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    return DeepGlassSurface(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(DeepWidgetTheme.panelRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Cách hoạt động',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 14),
          const _FeatureItem(
            title: '1. Chọn một ảnh',
            description: 'Dùng ảnh PNG, JPG hoặc WebP trong bộ sưu tập.',
          ),
          const SizedBox(height: 12),
          const _FeatureItem(
            title: '2. Chuẩn hóa thành PNG',
            description:
                'Deep Widget giữ kênh alpha, không ép ảnh lên nền màu đặc.',
          ),
          const SizedBox(height: 12),
          const _FeatureItem(
            title: '3. Ghim và thay đổi kích thước',
            description:
                'Ảnh luôn giữ tỉ lệ; khoảng trống và vùng alpha đều xuyên nền.',
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 2),
        Text(description, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ảnh chỉ được lưu cục bộ trên thiết bị của bạn.',
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: DeepWidgetColors.textSoft),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Đang chuẩn bị ảnh widget…',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: DeepGlassSurface(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Không thể chuẩn bị ảnh widget.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _GlassButton(onPressed: onRetry, label: 'Thử lại'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.onPressed, required this.label});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DeepGlassButton(onPressed: onPressed, label: label),
    );
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Không đọc được ảnh',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _TransparencyPainter extends CustomPainter {
  const _TransparencyPainter();

  static const double cellSize = 18;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (double y = 0; y < size.height; y += cellSize) {
      for (double x = 0; x < size.width; x += cellSize) {
        final int column = (x / cellSize).floor();
        final int row = (y / cellSize).floor();
        paint.color = (column + row).isEven
            ? DeepWidgetColors.checkerLight
            : DeepWidgetColors.checkerDark;
        canvas.drawRect(Rect.fromLTWH(x, y, cellSize, cellSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
