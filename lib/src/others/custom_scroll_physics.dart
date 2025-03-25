import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A custom [ScrollPhysics] that supports multiple behaviors:
/// - Android (clamping)
/// - iOS (bouncing)
/// - SpringyGlow (a modified spring simulation for overscroll)
/// - Snappy (a quick, springy response)
/// - SmoothSpring (a gentle, springy response)
///
/// You can also mix in the built‑in Flutter scroll physics as needed.
class CustomScrollPhysics extends ScrollPhysics {
  final ScrollPhysicsBehavior behavior;

  const CustomScrollPhysics({
    super.parent,
    this.behavior = ScrollPhysicsBehavior.android,
  });

  /// Factory that uses Android-style clamping physics.
  factory CustomScrollPhysics.android({ScrollPhysics? parent}) {
    return CustomScrollPhysics(
      behavior: ScrollPhysicsBehavior.android,
      parent: parent,
    );
  }

  /// Factory that uses iOS-style bouncing physics.
  factory CustomScrollPhysics.ios({ScrollPhysics? parent}) {
    return CustomScrollPhysics(
      behavior: ScrollPhysicsBehavior.ios,
      parent: parent,
    );
  }

  /// Factory that uses a modified spring simulation for overscroll,
  /// with a “glowy” effect. (Modified to fix overscroll target issues.)
  factory CustomScrollPhysics.springyGlow({ScrollPhysics? parent}) {
    return CustomScrollPhysics(
      behavior: ScrollPhysicsBehavior.springyGlow,
      parent: parent,
    );
  }

  /// Factory that uses a snappy spring simulation.
  factory CustomScrollPhysics.snappy({ScrollPhysics? parent}) {
    return CustomScrollPhysics(
      behavior: ScrollPhysicsBehavior.snappy,
      parent: parent,
    );
  }

  /// Factory that uses a smooth (gentle) spring simulation.
  factory CustomScrollPhysics.smoothSpring({ScrollPhysics? parent}) {
    return CustomScrollPhysics(
      behavior: ScrollPhysicsBehavior.smoothSpring,
      parent: parent,
    );
  }

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
      behavior: behavior,
      parent: buildParent(ancestor),
    );
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're nearly at rest and in bounds, no simulation is needed.
    if ((velocity.abs() < toleranceFor(position).velocity) &&
        !position.outOfRange) {
      return null;
    }

    switch (behavior) {
      case ScrollPhysicsBehavior.android:
        return ClampingScrollSimulation(
          position: position.pixels,
          velocity: velocity,
          tolerance: toleranceFor(position),
        );
      case ScrollPhysicsBehavior.ios:
        return BouncingScrollSimulation(
          spring: const SpringDescription(
            mass: 50,
            stiffness: 100,
            damping: 10,
          ),
          position: position.pixels,
          velocity: velocity,
          leadingExtent: position.minScrollExtent,
          trailingExtent: position.maxScrollExtent,
          tolerance: toleranceFor(position),
        );
      case ScrollPhysicsBehavior.springyGlow:
        // When overscrolled, bounce back to the boundary.
        double target;
        if (position.pixels < position.minScrollExtent) {
          target = position.minScrollExtent;
        } else if (position.pixels > position.maxScrollExtent) {
          target = position.maxScrollExtent;
        } else {
          // In bounds—simulate a gentle deceleration.
          target = position.pixels + (velocity > 0 ? 50.0 : -50.0);
        }
        return SpringSimulation(
          const SpringDescription(
            mass: 1,
            stiffness: 200,
            damping: 15,
          ),
          position.pixels,
          target,
          velocity,
        );
      case ScrollPhysicsBehavior.snappy:
        // A snappy spring simulation; the target is computed as a small offset.
        return SpringSimulation(
          const SpringDescription(
            mass: 1,
            stiffness: 500,
            damping: 30,
          ),
          position.pixels,
          // The target is arbitrarily set a bit ahead (or behind) depending on velocity.
          position.pixels + (velocity > 0 ? 100.0 : -100.0),
          velocity,
        );
      case ScrollPhysicsBehavior.smoothSpring:
        // A smooth, gentle spring simulation; the target is a larger offset.
        return SpringSimulation(
          const SpringDescription(
            mass: 1,
            stiffness: 150,
            damping: 20,
          ),
          position.pixels,
          position.pixels + (velocity > 0 ? 200.0 : -200.0),
          velocity,
        );
    }
  }
}

/// Supported scroll physics behaviors.
enum ScrollPhysicsBehavior {
  /// Android-style clamping physics.
  android,

  /// iOS-style bouncing physics.
  ios,

  /// A custom “springy glow” physics that bounces back when overscrolled.
  springyGlow,

  /// A snappy spring simulation for a quick scroll response.
  snappy,

  /// A smooth, gentle spring simulation for a relaxed feel.
  smoothSpring,
}
