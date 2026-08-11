import 'dart:ui';

import 'package:deepwidget/core/theme/deep_widget_colors.dart';
import 'package:deepwidget/core/theme/deep_widget_theme.dart';
import 'package:flutter/material.dart';

/// Applies the canonical control blur behind a Material button.
///
/// The button owns its fill, border and state shadow. Only the backdrop is
/// clipped so the active glow remains visible outside the one-pixel border.
class DeepGlassBackdrop extends StatelessWidget {
  const DeepGlassBackdrop({
    required this.child,
    super.key,
    this.borderRadius,
    this.blurSigma = DeepWidgetTheme.controlBlurSigma,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        borderRadius ?? BorderRadius.circular(DeepWidgetTheme.controlRadius);
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned.fill(
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Text-only action button using EMODINOT's explicit multi-layer stack.
///
/// Paint order: pre-blurred backdrop, symmetric outer glow/ring, then the
/// Material state surface containing the background, border and label.
class DeepGlassButton extends StatefulWidget {
  const DeepGlassButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  State<DeepGlassButton> createState() => _DeepGlassButtonState();
}

class _DeepGlassButtonState extends State<DeepGlassButton> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null;
    final Set<WidgetState> states = <WidgetState>{
      if (!enabled) WidgetState.disabled,
      if (_hovered) WidgetState.hovered,
      if (_focused) WidgetState.focused,
      if (_pressed) WidgetState.pressed,
    };
    final bool showGlow = enabled && (_hovered || _focused || _pressed);
    final Color background = DeepWidgetTheme.controlBackground(states);
    final BorderSide border = DeepWidgetTheme.controlBorder(states);
    final Color foreground = enabled
        ? DeepWidgetColors.text
        : DeepWidgetColors.textDisabled;
    final BorderRadius radius = BorderRadius.circular(
      DeepWidgetTheme.controlRadius,
    );
    final bool reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: widget.label,
      onTap: widget.onPressed,
      child: ExcludeSemantics(
        child: Focus(
          canRequestFocus: enabled,
          onFocusChange: (bool value) {
            if (_focused != value) setState(() => _focused = value);
          },
          child: MouseRegion(
            cursor: enabled
                ? SystemMouseCursors.click
                : SystemMouseCursors.forbidden,
            onEnter: enabled
                ? (_) {
                    if (!_hovered) setState(() => _hovered = true);
                  }
                : null,
            onExit: enabled
                ? (_) {
                    if (_hovered) setState(() => _hovered = false);
                  }
                : null,
            child: SizedBox(
              height: DeepWidgetTheme.controlHeight,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: radius,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: DeepWidgetTheme.controlBlurSigma,
                        sigmaY: DeepWidgetTheme.controlBlurSigma,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  DeepGlassOuterGlow(visible: showGlow, borderRadius: radius),
                  AnimatedContainer(
                    duration: reduceMotion
                        ? Duration.zero
                        : DeepWidgetTheme.controlDuration,
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: background,
                      border: Border.fromBorderSide(border),
                      borderRadius: radius,
                    ),
                  ),
                  Material(
                    color: DeepWidgetColors.transparent,
                    borderRadius: radius,
                    child: InkWell(
                      borderRadius: radius,
                      hoverColor: DeepWidgetColors.transparent,
                      focusColor: DeepWidgetColors.transparent,
                      highlightColor: DeepWidgetColors.transparent,
                      splashColor: DeepWidgetColors.transparent,
                      onHighlightChanged: enabled
                          ? (bool value) {
                              if (_pressed != value) {
                                setState(() => _pressed = value);
                              }
                            }
                          : null,
                      onTap: widget.onPressed,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: foreground,
                              fontFamily: DeepWidgetTheme.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders tiny invisible blur samples during the first 120 ms.
///
/// This compiles the control and menu blur pipelines before the user's first
/// interaction, matching EMODINOT and avoiding a late first blur frame.
class DeepBackdropBlurWarmUp extends StatefulWidget {
  const DeepBackdropBlurWarmUp({required this.child, super.key});

  static const Key controlWarmUpKey = ValueKey<String>(
    'deep-widget-blur-warmup-control',
  );
  static const Key menuWarmUpKey = ValueKey<String>(
    'deep-widget-blur-warmup-menu',
  );

  final Widget child;

  @override
  State<DeepBackdropBlurWarmUp> createState() => _DeepBackdropBlurWarmUpState();
}

class _DeepBackdropBlurWarmUpState extends State<DeepBackdropBlurWarmUp> {
  static const Duration _warmUpDuration = Duration(milliseconds: 120);

  bool _isWarmingUp = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(_warmUpDuration, () {
        if (mounted) setState(() => _isWarmingUp = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        widget.child,
        if (_isWarmingUp)
          const Positioned(
            left: 0,
            top: 0,
            child: IgnorePointer(
              child: ExcludeSemantics(child: _DeepBlurWarmUpSamples()),
            ),
          ),
      ],
    );
  }
}

class _DeepBlurWarmUpSamples extends StatelessWidget {
  const _DeepBlurWarmUpSamples();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _DeepBlurWarmUpSample(
          key: DeepBackdropBlurWarmUp.controlWarmUpKey,
          sigma: DeepWidgetTheme.controlBlurSigma,
        ),
        SizedBox(width: 1),
        _DeepBlurWarmUpSample(
          key: DeepBackdropBlurWarmUp.menuWarmUpKey,
          sigma: DeepWidgetTheme.menuBlurSigma,
        ),
      ],
    );
  }
}

class _DeepBlurWarmUpSample extends StatelessWidget {
  const _DeepBlurWarmUpSample({required this.sigma, super.key});

  final double sigma;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 8,
        height: 8,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: const ColoredBox(color: DeepWidgetColors.blurWarmUpSample),
          ),
        ),
      ),
    );
  }
}

/// Canonical EMODINOT glass surface for custom content.
class DeepGlassSurface extends StatefulWidget {
  const DeepGlassSurface({
    required this.child,
    super.key,
    this.active = false,
    this.enabled = true,
    this.hoverEffects = true,
    this.useBackdropBlur = true,
    this.showOuterGlow = true,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final bool active;
  final bool enabled;
  final bool hoverEffects;
  final bool useBackdropBlur;
  final bool showOuterGlow;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  State<DeepGlassSurface> createState() => _DeepGlassSurfaceState();
}

class _DeepGlassSurfaceState extends State<DeepGlassSurface> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.enabled && (widget.active || _focused);
    final bool hovered = widget.enabled && !active && _hovered;
    final Color background = active
        ? DeepWidgetColors.glassBackgroundActive
        : hovered
        ? DeepWidgetColors.glassBackgroundHover
        : widget.enabled
        ? DeepWidgetColors.glassBackground
        : DeepWidgetColors.disabledSurface;
    final Color border = active
        ? DeepWidgetColors.glassBorderActive
        : hovered
        ? DeepWidgetColors.glassBorderHover
        : DeepWidgetColors.glassBorder;
    final BorderRadius radius =
        widget.borderRadius ??
        BorderRadius.circular(DeepWidgetTheme.controlRadius);
    final bool hasOuterGlow = widget.showOuterGlow && (active || hovered);

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (bool value) {
        if (_focused != value) setState(() => _focused = value);
      },
      child: MouseRegion(
        onEnter: widget.hoverEffects
            ? (_) {
                if (!_hovered) setState(() => _hovered = true);
              }
            : null,
        onExit: widget.hoverEffects
            ? (_) {
                if (_hovered) setState(() => _hovered = false);
              }
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
          children: <Widget>[
            if (widget.useBackdropBlur)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: radius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: DeepWidgetTheme.controlBlurSigma,
                      sigmaY: DeepWidgetTheme.controlBlurSigma,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            Positioned.fill(
              child: DeepGlassOuterGlow(
                visible: hasOuterGlow,
                borderRadius: radius,
              ),
            ),
            ClipRRect(
              borderRadius: radius,
              child: _surfaceBody(background, border, radius),
            ),
          ],
        ),
      ),
    );
  }

  Widget _surfaceBody(Color background, Color border, BorderRadius radius) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(
          color: border,
          width: DeepWidgetTheme.controlBorderWidth,
        ),
        borderRadius: radius,
      ),
      child: widget.padding == null
          ? widget.child
          : Padding(padding: widget.padding!, child: widget.child),
    );
  }
}

class DeepGlassOuterGlow extends StatelessWidget {
  const DeepGlassOuterGlow({
    required this.visible,
    required this.borderRadius,
    super.key,
  });

  final bool visible;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        duration: reduceMotion
            ? Duration.zero
            : DeepWidgetTheme.controlDuration,
        curve: Curves.easeOut,
        tween: Tween<double>(end: visible ? 1 : 0),
        builder: (context, opacity, _) {
          return CustomPaint(
            painter: _DeepOuterGlowPainter(
              borderRadius: borderRadius,
              opacity: opacity,
            ),
          );
        },
      ),
    );
  }
}

class _DeepOuterGlowPainter extends CustomPainter {
  const _DeepOuterGlowPainter({
    required this.borderRadius,
    required this.opacity,
  });

  final BorderRadius borderRadius;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0 || size.isEmpty) return;

    final Rect bounds = Offset.zero & size;
    final RRect control = borderRadius.toRRect(bounds);
    final Rect layerBounds = bounds.inflate(32);
    final List<BoxShadow> shadows = <BoxShadow>[
      const BoxShadow(
        color: DeepWidgetColors.primaryGlow,
        blurRadius: 16,
        blurStyle: BlurStyle.outer,
      ),
      const BoxShadow(
        color: DeepWidgetColors.activeRing,
        spreadRadius: 1,
        blurStyle: BlurStyle.outer,
      ),
    ];

    canvas.saveLayer(layerBounds, Paint());
    for (final BoxShadow shadow in shadows) {
      final Paint paint = shadow
          .copyWith(
            color: shadow.color.withValues(alpha: shadow.color.a * opacity),
          )
          .toPaint();
      final Rect shadowBounds = bounds
          .shift(shadow.offset)
          .inflate(shadow.spreadRadius);
      canvas.drawRRect(borderRadius.toRRect(shadowBounds), paint);
    }
    canvas.drawRRect(control, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DeepOuterGlowPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.opacity != opacity;
  }
}
