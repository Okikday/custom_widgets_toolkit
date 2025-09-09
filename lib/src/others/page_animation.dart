// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

typedef TransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);

/// Parameterized, ergonomic transition descriptor with optimized performance.
abstract class TransitionType {
  const TransitionType();

  /// Build the transitionsBuilder used by PageRouteBuilder / CustomTransitionPage.
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve});

  // Preset singletons with const constructors for memory efficiency
  static const TransitionType none = _NoneTransition();
  static const TransitionType cupertino = _CupertinoTransition();
  static const TransitionType cupertinoDialog = _CupertinoDialogTransition();
  static const TransitionType download = _DownloadTransition();
  static const TransitionType fade = _FadeTransition();
  static const TransitionType fadeIn = _FadeTransition();
  static const TransitionType leftToRight = _LeftToRightTransition();
  static const TransitionType leftToRightWithFade = _LeftToRightWithFadeTransition();
  static const TransitionType native = _NativeTransition();
  static const TransitionType rightToLeft = _RightToLeftTransition();
  static const TransitionType rightToLeftWithFade = _RightToLeftWithFadeTransition();
  static const TransitionType size = _SizeTransitionPreset();
  static const TransitionType topLevel = _TopLevelTransition();
  static const TransitionType uptown = _UptownTransition();
  static const TransitionType zoom = _ZoomTransition();

  /// Creates a configurable slide transition with optional fade and parallax effects.
  factory TransitionType.slide({Offset? begin, Offset? end, bool fade = false, bool parallax = true}) =>
      _SlideTransition(begin: begin ?? const Offset(1, 0), end: end ?? Offset.zero, fade: fade, parallax: parallax);

  /// Creates a scale transition with customizable alignment and optional fade.
  factory TransitionType.scale({
    double from = 0.8,
    double to = 1.0,
    Alignment alignment = Alignment.center,
    bool fade = false,
  }) =>
      _ScaleTransition(from: from, to: to, alignment: alignment, fade: fade);

  /// Creates a uniform scale transition with optional fade.
  factory TransitionType.scaleXY({double from = 0.8, double to = 1.0, bool fade = false}) =>
      _ScaleXYTransition(from: from, to: to, fade: fade);

  /// Creates a paired transition where incoming and outgoing routes have different animations.
  factory TransitionType.paired({
    required TransitionType incoming,
    required TransitionType outgoing,
    Duration? outgoingDuration,
    Duration? reverseDuration,
    Curve? curve,
    Curve? reverseCurve,
  }) =>
      _PairedTransition(
        incoming: incoming,
        outgoing: outgoing,
        outgoingDuration: outgoingDuration,
        reverseDuration: reverseDuration,
        curve: curve,
        reverseCurve: reverseCurve,
      );
}

// Private implementations with optimized const constructors

final class _NoneTransition extends TransitionType {
  const _NoneTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) => _buildNone;

  static Widget _buildNone(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      child;
}

final class _FadeTransition extends TransitionType {
  const _FadeTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final curveTween = CurveTween(curve: curve);
    return (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation.drive(curveTween), child: child);
  }
}

final class _LeftToRightTransition extends TransitionType {
  const _LeftToRightTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final slideTween = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).chain(CurveTween(curve: curve));

    return (context, animation, secondaryAnimation, child) =>
        SlideTransition(position: animation.drive(slideTween), child: child);
  }
}

final class _LeftToRightWithFadeTransition extends TransitionType {
  const _LeftToRightWithFadeTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final slideTween = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).chain(CurveTween(curve: curve));
    final curveTween = CurveTween(curve: curve);

    return (context, animation, secondaryAnimation, child) => SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(opacity: animation.drive(curveTween), child: child),
        );
  }
}

final class _RightToLeftTransition extends TransitionType {
  const _RightToLeftTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final slideTween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: curve));

    return (context, animation, secondaryAnimation, child) =>
        SlideTransition(position: animation.drive(slideTween), child: child);
  }
}

final class _RightToLeftWithFadeTransition extends TransitionType {
  const _RightToLeftWithFadeTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final slideTween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: curve));
    final curveTween = CurveTween(curve: curve);

    return (context, animation, secondaryAnimation, child) => SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(opacity: animation.drive(curveTween), child: child),
        );
  }
}

final class _ZoomTransition extends TransitionType {
  const _ZoomTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final scaleTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

    return (context, animation, secondaryAnimation, child) {
      final scaleAnimation = animation.drive(scaleTween);
      return ScaleTransition(scale: scaleAnimation, child: FadeTransition(opacity: scaleAnimation, child: child));
    };
  }
}

final class _SizeTransitionPreset extends TransitionType {
  const _SizeTransitionPreset();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final curveTween = CurveTween(curve: curve);
    return (context, animation, secondaryAnimation, child) => Align(
          alignment: Alignment.topCenter,
          child: SizeTransition(sizeFactor: animation.drive(curveTween), axis: Axis.vertical, child: child),
        );
  }
}

final class _CupertinoTransition extends TransitionType {
  const _CupertinoTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final slideTween = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: curve));

    return (context, animation, secondaryAnimation, child) =>
        SlideTransition(position: animation.drive(slideTween), child: child);
  }
}

final class _CupertinoDialogTransition extends TransitionType {
  const _CupertinoDialogTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final scaleTween = Tween<double>(begin: 1.1, end: 1.0).chain(CurveTween(curve: curve));
    final curveTween = CurveTween(curve: curve);

    return (context, animation, secondaryAnimation, child) => FadeTransition(
          opacity: animation.drive(curveTween),
          child: ScaleTransition(scale: animation.drive(scaleTween), child: child),
        );
  }
}

final class _NativeTransition extends TransitionType {
  const _NativeTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final curveTween = CurveTween(curve: curve);
    final scaleTween = Tween<double>(begin: 0.94, end: 1.0).chain(CurveTween(curve: curve));

    return (context, animation, secondaryAnimation, child) => FadeTransition(
          opacity: animation.drive(curveTween),
          child: ScaleTransition(scale: animation.drive(scaleTween), child: child),
        );
  }
}

final class _DownloadTransition extends TransitionType {
  const _DownloadTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final slideTween = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).chain(CurveTween(curve: curve));

    return (context, animation, secondaryAnimation, child) =>
        SlideTransition(position: animation.drive(slideTween), child: child);
  }
}

final class _UptownTransition extends TransitionType {
  const _UptownTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final slideTween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: curve));

    return (context, animation, secondaryAnimation, child) =>
        SlideTransition(position: animation.drive(slideTween), child: child);
  }
}

final class _TopLevelTransition extends TransitionType {
  const _TopLevelTransition();

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final scaleTween = Tween<double>(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));
    final curveTween = CurveTween(curve: curve);

    return (context, animation, secondaryAnimation, child) => FadeTransition(
          opacity: animation.drive(curveTween),
          child: ScaleTransition(scale: animation.drive(scaleTween), child: child),
        );
  }
}

final class _SlideTransition extends TransitionType {
  const _SlideTransition({required this.begin, required this.end, required this.fade, required this.parallax});

  final Offset begin;
  final Offset end;
  final bool fade;
  final bool parallax;

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final primaryTween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
    final curveTween = fade ? CurveTween(curve: curve) : null;
    final secondaryTween = parallax
        ? Tween<Offset>(
            begin: Offset.zero,
            end: Offset(-begin.dx * 0.2, -begin.dy * 0.2),
          ).chain(CurveTween(curve: curve))
        : null;

    return (context, animation, secondaryAnimation, child) {
      Widget result = SlideTransition(position: animation.drive(primaryTween), child: child);

      if (fade) {
        result = FadeTransition(opacity: animation.drive(curveTween!), child: result);
      }

      if (parallax && secondaryTween != null) {
        result = AnimatedBuilder(
          animation: secondaryAnimation,
          builder: (context, child) =>
              Transform.translate(offset: secondaryAnimation.drive(secondaryTween).value, child: child),
          child: result,
        );
      }

      return result;
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SlideTransition &&
          other.begin == begin &&
          other.end == end &&
          other.fade == fade &&
          other.parallax == parallax;

  @override
  int get hashCode => Object.hash(begin, end, fade, parallax);
}

/// Optimized scale transition with configurable alignment and fade.
final class _ScaleTransition extends TransitionType {
  const _ScaleTransition({required this.from, required this.to, required this.alignment, required this.fade});

  final double from;
  final double to;
  final Alignment alignment;
  final bool fade;

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final scaleTween = Tween<double>(begin: from, end: to).chain(CurveTween(curve: curve));
    final curveTween = fade ? CurveTween(curve: curve) : null;

    return (context, animation, secondaryAnimation, child) {
      Widget result = ScaleTransition(scale: animation.drive(scaleTween), alignment: alignment, child: child);

      if (fade) {
        result = FadeTransition(opacity: animation.drive(curveTween!), child: result);
      }

      return result;
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ScaleTransition &&
          other.from == from &&
          other.to == to &&
          other.alignment == alignment &&
          other.fade == fade;

  @override
  int get hashCode => Object.hash(from, to, alignment, fade);
}

final class _ScaleXYTransition extends TransitionType {
  const _ScaleXYTransition({required this.from, required this.to, required this.fade});

  final double from;
  final double to;
  final bool fade;

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final scaleTween = Tween<double>(begin: from, end: to).chain(CurveTween(curve: curve));
    final curveTween = fade ? CurveTween(curve: curve) : null;

    return (context, animation, secondaryAnimation, child) {
      Widget result = ScaleTransition(scale: animation.drive(scaleTween), alignment: Alignment.center, child: child);

      if (fade) {
        result = FadeTransition(opacity: animation.drive(curveTween!), child: result);
      }

      return result;
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ScaleXYTransition && other.from == from && other.to == to && other.fade == fade;

  @override
  int get hashCode => Object.hash(from, to, fade);
}

final class _PairedTransition extends TransitionType {
  const _PairedTransition({
    required this.incoming,
    required this.outgoing,
    this.outgoingDuration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
  });

  final TransitionType incoming;
  final TransitionType outgoing;
  final Duration? outgoingDuration;
  final Duration? reverseDuration;
  final Curve? curve;
  final Curve? reverseCurve;

  @override
  TransitionBuilder builder(Curve curve, {Curve? reverseCurve}) {
    final effectiveCurve = this.curve ?? curve;
    final effectiveReverseCurve = this.reverseCurve ?? reverseCurve ?? effectiveCurve;

    final incomingBuilder = incoming.builder(effectiveCurve, reverseCurve: effectiveReverseCurve);
    final outgoingBuilder = outgoing.builder(effectiveCurve, reverseCurve: effectiveReverseCurve);

    return (context, animation, secondaryAnimation, child) {
      // Check if this is the outgoing route (being pushed out by a new route)
      // The secondary animation drives when this route is being covered by another
      if (secondaryAnimation.status == AnimationStatus.forward ||
          (secondaryAnimation.status == AnimationStatus.reverse && secondaryAnimation.value > 0.0)) {
        // This route is being pushed out, use outgoing animation
        return outgoingBuilder(context, secondaryAnimation, animation, child);
      }

      // This is the incoming route, use incoming animation
      return incomingBuilder(context, animation, secondaryAnimation, child);
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PairedTransition &&
          other.incoming == incoming &&
          other.outgoing == outgoing &&
          other.outgoingDuration == outgoingDuration &&
          other.reverseDuration == reverseDuration &&
          other.curve == curve &&
          other.reverseCurve == reverseCurve;

  @override
  int get hashCode => Object.hash(incoming, outgoing, outgoingDuration, reverseDuration, curve, reverseCurve);
}

/// Enhanced CustomTransitionPage with paired transition duration support.
class CustomTransitionPage<T> extends Page<T> {
  const CustomTransitionPage({
    required this.child,
    required this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.transitionType,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final TransitionBuilder transitionsBuilder;
  final TransitionType? transitionType;

  @override
  Route<T> createRoute(BuildContext context) => _CustomTransitionPageRoute<T>(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomTransitionPage &&
          other.key == key &&
          other.child == child &&
          other.transitionDuration == transitionDuration &&
          other.reverseTransitionDuration == reverseTransitionDuration &&
          other.maintainState == maintainState &&
          other.fullscreenDialog == fullscreenDialog &&
          other.opaque == opaque &&
          other.barrierDismissible == barrierDismissible &&
          other.barrierColor == barrierColor &&
          other.barrierLabel == barrierLabel &&
          other.transitionType == transitionType;

  @override
  int get hashCode => Object.hash(
        key,
        child,
        transitionDuration,
        reverseTransitionDuration,
        maintainState,
        fullscreenDialog,
        opaque,
        barrierDismissible,
        barrierColor,
        barrierLabel,
        transitionType,
      );
}

/// Enhanced route implementation with proper paired transition duration handling.
final class _CustomTransitionPageRoute<T> extends PageRoute<T> {
  _CustomTransitionPageRoute(this._page) : super(settings: _page);

  final CustomTransitionPage<T> _page;

  @override
  bool get barrierDismissible => _page.barrierDismissible;

  @override
  Color? get barrierColor => _page.barrierColor;

  @override
  String? get barrierLabel => _page.barrierLabel;

  @override
  Duration get transitionDuration => _getDuration(forward: true);

  @override
  Duration get reverseTransitionDuration => _getDuration(forward: false);

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  bool get opaque => _page.opaque;

  Duration _getDuration({required bool forward}) {
    // Handle paired transition durations
    if (_page.transitionType is _PairedTransition) {
      final pairedTransition = _page.transitionType as _PairedTransition;
      if (forward) {
        return _page.transitionDuration; // Use incoming duration
      } else {
        return pairedTransition.reverseDuration ?? pairedTransition.outgoingDuration ?? _page.reverseTransitionDuration;
      }
    }

    return forward ? _page.transitionDuration : _page.reverseTransitionDuration;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      Semantics(scopesRoute: true, explicitChildNodes: true, child: _page.child);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      _page.transitionsBuilder(context, animation, secondaryAnimation, child);
}

class PageAnimation {
  PageAnimation._();

  /// Creates a CustomTransitionPage with the specified transition configuration.
  static CustomTransitionPage<T> buildCustomTransitionPage<T>(
    LocalKey key, {
    required Widget child,
    TransitionType type = TransitionType.native,
    Curve? curve,
    Curve? reverseCurve,
    Duration duration = const Duration(milliseconds: 300),
    Duration reverseDuration = const Duration(milliseconds: 300),
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    // Assert that curve parameters are not set when using paired transitions
    // to avoid conflicting configurations
    assert(
      !(type is _PairedTransition && curve != null),
      'Cannot specify curve parameter when using TransitionType.paired. '
      'Set curves directly in the paired transition constructor instead.',
    );
    assert(
      !(type is _PairedTransition && reverseCurve != null),
      'Cannot specify reverseCurve parameter when using TransitionType.paired. '
      'Set curves directly in the paired transition constructor instead.',
    );

    final effectiveCurve = curve ?? CustomCurves.ease;

    Curve? finalCurve = effectiveCurve;
    Curve? finalReverseCurve = reverseCurve;

    if (type is _PairedTransition) {
      finalCurve = type.curve ?? CustomCurves.ease;
      finalReverseCurve = type.reverseCurve ?? finalCurve;
    }

    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: type.builder(finalCurve, reverseCurve: finalReverseCurve),
      barrierDismissible: barrierDismissible,
      opaque: opaque,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionType: type,
    );
  }

  /// Creates a PageRouteBuilder with the specified transition configuration.
  static PageRouteBuilder<T> pageRouteBuilder<T>(
    Widget child, {
    TransitionType type = TransitionType.native,
    Curve? curve,
    Curve? reverseCurve,
    Duration duration = const Duration(milliseconds: 300),
    Duration reverseDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
  }) {
    // Assert that curve parameters are not set when using paired transitions
    assert(
      !(type is _PairedTransition && curve != null),
      'Cannot specify curve parameter when using TransitionType.paired. '
      'Set curves directly in the paired transition constructor instead.',
    );
    assert(
      !(type is _PairedTransition && reverseCurve != null),
      'Cannot specify reverseCurve parameter when using TransitionType.paired. '
      'Set curves directly in the paired transition constructor instead.',
    );

    final effectiveCurve = curve ?? CustomCurves.ease;

    // Handle paired transitions properly
    Curve? finalCurve = effectiveCurve;
    Curve? finalReverseCurve = reverseCurve;
    Duration finalDuration = duration;
    Duration finalReverseDuration = reverseDuration;

    if (type is _PairedTransition) {
      finalCurve = type.curve ?? CustomCurves.ease;
      finalReverseCurve = type.reverseCurve ?? finalCurve;
      // Use paired transition durations if specified
      if (type.outgoingDuration != null) finalDuration = type.outgoingDuration!;
      if (type.reverseDuration != null) finalReverseDuration = type.reverseDuration!;
    }

    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: type.builder(finalCurve, reverseCurve: finalReverseCurve),
      transitionDuration: finalDuration,
      reverseTransitionDuration: finalReverseDuration,
      settings: settings,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
    );
  }
}

/// Zero-transition page for instant navigation.
class NoTransitionPage<T> extends CustomTransitionPage<T> {
  const NoTransitionPage({required super.child, super.name, super.arguments, super.restorationId, super.key})
      : super(
          transitionsBuilder: _noTransition,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

  static Widget _noTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      child;
}
