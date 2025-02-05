import 'dart:math';
import 'package:flutter/animation.dart';

class CustomSpringCurves {
  /// Default smooth spring curve similar to iOS system animations (original).
  static Curve get smoothSpring => _CustomSpringCurve(
        damping: 10,
        stiffness: 200,
      );

  /// Snappy curve, mimicking a quick and energetic animation (original).
  static Curve get snappy => _CustomSpringCurve(
        damping: 8,
        stiffness: 400,
      );

  /// Gentle curve for soft transitions (original).
  static Curve get gentle => _CustomSpringCurve(
        damping: 15,
        stiffness: 150,
      );

  /// Bouncy curve for playful animations (original).
  static Curve get bouncy => _CustomSpringCurve(
        damping: 6,
        stiffness: 500,
      );

  /// Relaxed spring curve for long easing transitions (original).
  static Curve get relaxed => _CustomSpringCurve(
        damping: 12,
        stiffness: 120,
      );

  /// iOS default spring curve from Apple's default settings.
  ///
  /// Derived from:
  /// ```dart
  /// durationSeconds: 0.55,
  /// bounce: 0,  // (i.e. dampingFraction = 1)
  /// stiffness = (2 * pi / 0.55)² ≈ 130.4,
  /// damping   = 4 * pi / 0.55 ≈ 22.9.
  /// ```
  static Curve get iosDefault => _CustomSpringCurve(
        damping: 4 * pi / 0.55, // ≈ 22.90
        stiffness: pow(2 * pi / 0.55, 2).toDouble(), // ≈ 130.36
      );

  /// Interactive spring curve for fast, responsive animations.
  ///
  /// Derived from:
  /// ```dart
  /// durationSeconds: 0.15,
  /// dampingFraction: 0.86,
  /// stiffness = (2 * pi / 0.15)² ≈ 1755,
  /// damping   = 4 * pi * 0.86 / 0.15 ≈ 72.1.
  /// ```
  static Curve get interactive => _CustomSpringCurve(
        damping: 4 * pi * 0.86 / 0.15, // ≈ 72.11
        stiffness: pow(2 * pi / 0.15, 2).toDouble(), // ≈ 1755
      );
}

class _CustomSpringCurve extends Curve {
  final double damping;
  final double stiffness;

  const _CustomSpringCurve({required this.damping, required this.stiffness});

  @override
  double transform(double t) {
    // Compute the angular frequency
    final omega = sqrt(stiffness);
    // Calculate damping ratio (zeta)
    final zeta = damping / (2 * omega);
    // Exponential decay factor
    final exponentialDecay = exp(-zeta * omega * t);
    // Oscillatory factor (with a check for under-damped motion)
    final oscillation = cos(omega * sqrt(1 - zeta * zeta) * t);
    return 1 - (exponentialDecay * oscillation);
  }
}
