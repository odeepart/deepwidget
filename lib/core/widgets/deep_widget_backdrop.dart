import 'package:deepwidget/core/theme/deep_widget_colors.dart';
import 'package:flutter/material.dart';

class DeepWidgetBackdrop extends StatelessWidget {
  const DeepWidgetBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DeepWidgetColors.background,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const IgnorePointer(child: _AmbientGlow()),
          child,
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const <Widget>[
        Positioned(top: -120, right: -110, child: _GlowOrb(size: 300)),
        Positioned(bottom: -180, left: -140, child: _GlowOrb(size: 360)),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              DeepWidgetColors.primarySoft,
              DeepWidgetColors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
