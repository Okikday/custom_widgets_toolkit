// file: custom_curves.dart
import 'dart:math';
import 'package:flutter/animation.dart';

/// A unified collection of spring‑based curves (implemented inline)
/// along with several additional smooth easing curves defined using our
/// custom _LambdaCurve implementation.
class CustomCurves {
  // ========================================================================
  // Spring‑Based Curves (implemented inline)
  // ========================================================================
  static const double _defaultDuration = 0.5;

  static final Curve instantSpring =
      _createSpringCurve(durationSeconds: 0, bounce: 0, id: 'instantSpring');
  static final Curve defaultIosSpring = _createSpringCurve(
      durationSeconds: 0.55, bounce: 0, id: 'defaultIosSpring');
  static final Curve bouncySpring = _createSpringCurve(
      durationSeconds: _defaultDuration, bounce: 0.3, id: 'bouncySpring');
  static final Curve snappySpring = _createSpringCurve(
      durationSeconds: _defaultDuration, bounce: 0.15, id: 'snappySpring');
  static final Curve interactiveSpring = _createSpringCurve(
      durationSeconds: 0.15, bounce: 0.14, id: 'interactiveSpring');

  // ========================================================================
  // Additional Custom Curves (using inline lambda functions)
  // ========================================================================

  /// Linear curve: f(t) = t.
  static final Curve linear = _LambdaCurve(
    id: 'linear',
    transformFunction: (t) => t,
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  /// Ease curve (smoothstep): f(t) = t*t*(3 - 2*t).
  static final Curve ease = _LambdaCurve(
    id: 'ease',
    transformFunction: (t) => t * t * (3 - 2 * t),
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  /// Decelerate curve: f(t) = 1 - (1-t)^2.
  static final Curve decelerate = _LambdaCurve(
    id: 'decelerate',
    transformFunction: (t) => 1 - pow(1 - t, 2).toDouble(),
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  /// FastSlowInOut (approximated via an easeInOutCubic formula):
  /// f(t) = { 4*t^3                   if t < 0.5
  ///         1 - (-2*t + 2)^3 / 2      if t >= 0.5 }
  static final Curve fastSlowInOut = _LambdaCurve(
    id: 'fastSlowInOut',
    transformFunction: (t) {
      if (t < 0.5) {
        return 4 * t * t * t;
      } else {
        return 1 - pow(-2 * t + 2, 3).toDouble() / 2;
      }
    },
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  /// BounceOut curve: a common bounce effect implementation.
  static final Curve bounceOut = _LambdaCurve(
    id: 'bounceOut',
    transformFunction: (t) {
      if (t < 1 / 2.75) {
        return 7.5625 * t * t;
      } else if (t < 2 / 2.75) {
        t = t - (1.5 / 2.75);
        return 7.5625 * t * t + 0.75;
      } else if (t < 2.5 / 2.75) {
        t = t - (2.25 / 2.75);
        return 7.5625 * t * t + 0.9375;
      } else {
        t = t - (2.625 / 2.75);
        return 7.5625 * t * t + 0.984375;
      }
    },
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  /// BounceIn is defined as the inverse of BounceOut:
  /// f(t) = 1 - bounceOut(1 - t).
  static final Curve bounceIn = _LambdaCurve(
    id: 'bounceIn',
    transformFunction: (t) => 1 - bounceOut.transform(1 - t),
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  // ========================================================================
  // Additional Smooth Easing Curves
  // ========================================================================

  /// Ease Out Sine: f(t) = sin((π * t) / 2).
  static final Curve easeOutSine = _LambdaCurve(
    id: 'easeOutSine',
    transformFunction: (t) => sin((t * pi) / 2),
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  /// Ease In Out Sine: f(t) = -(cos(π * t) - 1) / 2.
  static final Curve easeInOutSine = _LambdaCurve(
    id: 'easeInOutSine',
    transformFunction: (t) => -(cos(pi * t) - 1) / 2,
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  /// Ease Out Circ: f(t) = sqrt(1 - (t - 1)^2).
  static final Curve easeOutCirc = _LambdaCurve(
    id: 'easeOutCirc',
    transformFunction: (t) => sqrt(1 - pow(t - 1, 2).toDouble()),
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  /// Ease In Out Circ:
  /// f(t) = (t < 0.5) ? (1 - sqrt(1 - (2*t)^2)) / 2 : (sqrt(1 - (-2*t + 2)^2) + 1) / 2.
  static final Curve easeInOutCirc = _LambdaCurve(
    id: 'easeInOutCirc',
    transformFunction: (t) {
      if (t < 0.5) {
        return (1 - sqrt(1 - pow(2 * t, 2).toDouble())) / 2;
      } else {
        return (sqrt(1 - pow(-2 * t + 2, 2).toDouble()) + 1) / 2;
      }
    },
    durationSeconds: _defaultDuration,
    bounce: 0,
  );

  // ========================================================================
  // Private helper: creates a spring‑based curve.
  // ========================================================================
  static Curve _createSpringCurve({
    required double durationSeconds,
    required double bounce,
    required String id,
  }) {
    final double stiffness;
    final double damping;
    if (durationSeconds <= 0) {
      stiffness = 1e16;
      damping = 1e4;
    } else {
      stiffness = pow(2 * pi / durationSeconds, 2).toDouble();
      damping = 4 * pi * (1 - bounce) / durationSeconds;
    }

    return _LambdaCurve(
      id: id,
      transformFunction: (double t) {
        final double omega = sqrt(stiffness);
        final double zeta = damping / (2 * omega);
        if (zeta < 1) {
          final double omegaD = omega * sqrt(1 - zeta * zeta);
          return 1 -
              exp(-zeta * omega * t) *
                  (cos(omegaD * t) +
                      (zeta / sqrt(1 - zeta * zeta)) * sin(omegaD * t));
        } else {
          // Critically damped or overdamped response.
          return 1 - exp(-omega * t) * (1 + omega * t);
        }
      },
      durationSeconds: durationSeconds,
      bounce: bounce,
    );
  }
}

/// A [Curve] implementation that wraps a transform function and
/// stores its parameters (including a unique id) for meaningful equality checks.
class _LambdaCurve extends Curve {
  final String id;
  final double Function(double) transformFunction;
  final double durationSeconds;
  final double bounce;

  const _LambdaCurve({
    required this.id,
    required this.transformFunction,
    required this.durationSeconds,
    required this.bounce,
  });

  @override
  double transform(double t) => transformFunction(t);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _LambdaCurve &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          durationSeconds == other.durationSeconds &&
          bounce == other.bounce;

  @override
  int get hashCode => id.hashCode ^ durationSeconds.hashCode ^ bounce.hashCode;
}
