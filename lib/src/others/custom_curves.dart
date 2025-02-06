// file: custom_curves.dart
import 'dart:math';
import 'package:flutter/animation.dart';

/// A unified collection of both Flutter's built‑in easing curves and
/// spring‑based curves (implemented standalone, without depending on
/// your original Spring or CustomSpringCurves classes).
///
/// Usage:
///   - Flutter curves: CustomCurves.easeIn, CustomCurves.decelerate, etc.
///   - Spring-based curves: CustomCurves.defaultIos, CustomCurves.bouncy, etc.
class CustomCurves {
  // ===========================================================================
  // Flutter's Built‑in Easing Curves
  // ===========================================================================
  static const Curve linear = Curves.linear;
  static const Curve ease = Curves.ease;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve decelerate = Curves.decelerate;

  // ===========================================================================
  // Spring‑Based Curves (standalone implementations)
  // ===========================================================================
  //
  // The following curves are created using a spring response formula.
  // They are based on parameters similar to those you provided in your
  // Spring class but re‑implemented here without any dependency on that class.
  //
  // Note: Because methods like sqrt() and exp() are used, these curves cannot
  // be defined as compile‑time constants. They are declared as static finals.
  //
  // Presets:
  //   • instant:       An effectively immediate response.
  //   • defaultIos:    Duration 0.55 sec, no bounce.
  //   • bouncy:        (bounce: 0.3) with default duration 0.5 sec.
  //   • snappy:        (bounce: 0.15) with default duration 0.5 sec.
  //   • interactive:   (bounce: ~0.14) with a very short duration 0.15 sec.
  //
  static const double _defaultDuration = 0.5;

  static final Curve instant = _SpringBasedCurve._instant();
  static final Curve defaultIos = _SpringBasedCurve(durationSeconds: 0.55, bounce: 0);
  static final Curve bouncy = _SpringBasedCurve(durationSeconds: _defaultDuration, bounce: 0.3);
  static final Curve snappy = _SpringBasedCurve(durationSeconds: _defaultDuration, bounce: 0.15);
  static final Curve interactive = _SpringBasedCurve(durationSeconds: 0.15, bounce: 0.14);
}

/// A private, standalone Curve that simulates a spring response.
/// It computes its parameters based on a given response duration and bounce.
class _SpringBasedCurve extends Curve {
  /// The time (in seconds) for the spring response.
  final double durationSeconds;

  /// The bounce value (from –1 to 1), where 0 means critical damping.
  final double bounce;

  /// The computed stiffness based on [durationSeconds].
  final double stiffness;

  /// The computed damping based on [durationSeconds] and [bounce].
  final double damping;

  /// Constructs a spring-based curve given a [durationSeconds] and [bounce].
  ///
  /// If [durationSeconds] is zero, it uses preset "instant" values.
  _SpringBasedCurve({
    required this.durationSeconds,
    required this.bounce,
  })  : stiffness = durationSeconds > 0
            ? pow(2 * pi / durationSeconds, 2).toDouble()
            : _instantStiffness,
        damping = durationSeconds > 0
            ? 4 * pi * (1 - bounce) / durationSeconds
            : _instantDamping;

  /// Named constructor for an effectively instant spring.
  const _SpringBasedCurve._instant()
      : durationSeconds = 0,
        bounce = 0,
        stiffness = _instantStiffness,
        damping = _instantDamping;

  static const double _instantStiffness = 1e16; // A very high stiffness.
  static const double _instantDamping = 1e4;      // A very high damping.

  @override
  double transform(double t) {
    // Compute the angular frequency.
    final double omega = sqrt(stiffness);
    // Compute the damping ratio.
    final double zeta = damping / (2 * omega);

    // For underdamped systems (zeta < 1) we get an oscillatory response.
    if (zeta < 1) {
      final double omegaD = omega * sqrt(1 - zeta * zeta);
      return 1 -
          exp(-zeta * omega * t) *
              (cos(omegaD * t) +
                  (zeta / sqrt(1 - zeta * zeta)) * sin(omegaD * t));
    } else {
      // For critically damped or overdamped systems, use a simpler formula.
      return 1 - exp(-omega * t) * (1 + omega * t);
    }
  }
}
