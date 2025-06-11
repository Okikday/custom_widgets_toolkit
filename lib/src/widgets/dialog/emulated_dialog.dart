import 'dart:ui';
import 'package:custom_widgets_toolkit/src/others/custom_curves.dart';
import 'package:flutter/material.dart';

class EmulatedDialog extends StatefulWidget {
  final bool canPop;
  final bool adaptToScreenSize;
  final Color? barrierColor;
  final Offset blurSigma;
  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  /// Use CustomCurves
  final Curve? curve;

  const EmulatedDialog({
    super.key,
    this.canPop = false,
    this.adaptToScreenSize = false,
    this.blurSigma = const Offset(2.0, 2.0),
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
  int msgIndex = 0;
  late final AnimationController _blurController;
  late final Animation<Offset> _curvedBlurAnimation;
  late final ColorTween _scaffoldBgColorTween;

  @override
  void initState() {
    super.initState();
    _blurController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
      reverseDuration: widget.reverseTransitionDuration,
    )..forward(from: 0);
    _curvedBlurAnimation = Tween<Offset>(begin: Offset.zero, end: widget.blurSigma).animate(CurvedAnimation(
      parent: _blurController,
      curve: widget.curve ?? CustomCurves.decelerate,
      reverseCurve: widget.curve,
    ));
    _scaffoldBgColorTween = ColorTween(begin: Colors.blueGrey.withAlpha(10), end: widget.barrierColor ?? Colors.blueGrey.withAlpha(10));
  }

  @override
  void dispose() {
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
        canPop: widget.canPop,
        onPopInvokedWithResult: (didPop, result) {
          if (widget.canPop) _blurController.reverse();
        },
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _blurController,
            builder: (context, child) {
              final Color? color = _scaffoldBgColorTween.evaluate(_blurController);
              return Scaffold(
                backgroundColor: color,
                body: child,
              );
            },
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _curvedBlurAnimation,
                builder: (context, child) {
                  return RepaintBoundary(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _curvedBlurAnimation.value.dx,
                        sigmaY: _curvedBlurAnimation.value.dy,
                      ),
                      child: widget.child,
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}