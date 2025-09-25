import 'dart:ui';
import 'package:custom_widgets_toolkit/src/others/custom_curves.dart';
import 'package:flutter/material.dart';

class EmulatedDialog extends StatefulWidget {
  final bool canPop;
  final bool adaptToScreenSize;
  final Color? barrierColor;
  final Offset? blurSigma;
  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Curve? curve;

  const EmulatedDialog({
    super.key,
    this.canPop = false,
    this.adaptToScreenSize = false,
    this.blurSigma,
    required this.child,
    this.barrierColor,
    this.curve,
    this.transitionDuration = Durations.medium4,
    this.reverseTransitionDuration = Durations.medium1,
  });

  @override
  State<EmulatedDialog> createState() => _EmulatedDialogState();
}

class _EmulatedDialogState extends State<EmulatedDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _blurAnimation;
  late final Animation<Color?> _colorAnimation;

  late final bool _hasBlur;
  late final Color _startColor;
  late final Color _endColor;

  @override
  void initState() {
    super.initState();

    _hasBlur = widget.blurSigma != null && (widget.blurSigma!.dx > 0 || widget.blurSigma!.dy > 0);

    _startColor = Colors.transparent;
    _endColor = widget.barrierColor ?? Colors.black.withValues(alpha: 0.4);

    _controller = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
      reverseDuration: widget.reverseTransitionDuration,
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? CustomCurves.decelerate,
    );

    _blurAnimation = _hasBlur ? Tween<double>(begin: 0.0, end: 1.0).animate(curve) : kAlwaysCompleteAnimation;

    _colorAnimation = ColorTween(
      begin: _startColor,
      end: _endColor,
    ).animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (widget.canPop && !didPop) {
          _controller.reverse();
        }
      },
      child: _hasBlur
          ? _BlurredDialogContent(
              controller: _controller,
              blurAnimation: _blurAnimation,
              colorAnimation: _colorAnimation,
              blurSigma: widget.blurSigma!,
              child: widget.child,
            )
          : _SimpleDialogContent(
              colorAnimation: _colorAnimation,
              child: widget.child,
            ),
    );
  }
}

class _BlurredDialogContent extends StatelessWidget {
  const _BlurredDialogContent({
    required this.controller,
    required this.blurAnimation,
    required this.colorAnimation,
    required this.blurSigma,
    required this.child,
  });

  final AnimationController controller;
  final Animation<double> blurAnimation;
  final Animation<Color?> colorAnimation;
  final Offset blurSigma;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final blurValue = blurAnimation.value;
          return Scaffold(
            backgroundColor: colorAnimation.value,
            body: blurValue > 0
                ? RepaintBoundary(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: blurSigma.dx * blurValue,
                        sigmaY: blurSigma.dy * blurValue,
                      ),
                      child: child,
                    ),
                  )
                : child,
          );
        },
      ),
    );
  }
}

class _SimpleDialogContent extends StatelessWidget {
  const _SimpleDialogContent({
    required this.colorAnimation,
    required this.child,
  });

  final Animation<Color?> colorAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: colorAnimation,
        builder: (context, _) => Scaffold(
          backgroundColor: colorAnimation.value,
          body: child,
        ),
      ),
    );
  }
}
