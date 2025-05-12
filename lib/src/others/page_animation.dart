
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Page with custom transition functionality.
/// To be used instead of MaterialPage or CupertinoPage, which provide
/// their own transitions.
library;


import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/widgets.dart';

/// Enumerates all supported transition types, modeled after GetX styles.
enum TransitionType {
  cupertino,
  cupertinoDialog,
  download,
  fade,
  fadeIn,
  leftToRight,
  leftToRightWithFade,
  native,
  rightToLeft,
  rightToLeftWithFade,
  size,
  topLevel,
  uptown,
  zoom,
}


/// Signature for transition builder functions.
/// Receives primary and secondary animations plus the child widget.
typedef TransitionBuilder =
    Widget Function(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child);

/// Centralized utility for creating animated page transitions
/// without external dependencies.
class PageAnimation {

  /// Single entry-point: builds a [CustomTransitionPage] by TransitionType type
  /// Returns a [CustomTransitionPage] wrapping [child], with
  /// animation determined by [type] and [curve].
  static CustomTransitionPage<T> buildCustomTransitionPage<T>(
    LocalKey key, {
    required Widget child,
    TransitionType type = TransitionType.native,
    Curve? curve,
    Duration duration = const Duration(milliseconds: 300),
    Duration reverseDuration = const Duration(milliseconds: 300),
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    final transition = _transitionBuilder(type, curve ?? CustomCurves.ease);
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: transition,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// Returns a [PageRouteBuilder] for [child], using the specified
  /// [type], [curve], durations, and optional [settings].
  static PageRouteBuilder<T> pageRouteBuilder<T>(
    Widget child, {
    TransitionType type = TransitionType.native,
    Curve? curve,
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
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: _transitionBuilder(type, curve ?? CustomCurves.ease),
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      settings: settings,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
    );
  }


  static TransitionBuilder _transitionBuilder(TransitionType type, Curve curve) {
    switch (type) {
      case TransitionType.fade:
      case TransitionType.fadeIn:
        return (context, animation, secondary, child) => FadeTransition(opacity: animation.drive(CurveTween(curve: curve)), child: child);

      case TransitionType.leftToRight:
        return (context, animation, secondary, child) {
          final offset = animation.drive(Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero).chain(CurveTween(curve: curve)));
          return SlideTransition(position: offset, child: child);
        };

      case TransitionType.leftToRightWithFade:
        return (context, animation, secondary, child) {
          final slide = animation.drive(Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero).chain(CurveTween(curve: curve)));
          final fade = animation.drive(CurveTween(curve: curve));
          return SlideTransition(position: slide, child: FadeTransition(opacity: fade, child: child));
        };

      case TransitionType.rightToLeft:
        return (context, animation, secondary, child) {
          final offset = animation.drive(Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: curve)));
          return SlideTransition(position: offset, child: child);
        };

      case TransitionType.rightToLeftWithFade:
        return (context, animation, secondary, child) {
          final slide = animation.drive(Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: curve)));
          final fade = animation.drive(CurveTween(curve: curve));
          return SlideTransition(position: slide, child: FadeTransition(opacity: fade, child: child));
        };

      case TransitionType.zoom:
        return (context, animation, secondary, child) {
          final zoomAnimation = animation.drive(Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)));
          return ScaleTransition(scale: zoomAnimation, child: FadeTransition(opacity: zoomAnimation, child: child));
        };

      case TransitionType.size:
        return (context, animation, secondary, child) {
          return Align(
            alignment: Alignment.topCenter,
            child: SizeTransition(sizeFactor: animation.drive(CurveTween(curve: curve)), axis: Axis.vertical, child: child),
          );
        };

      case TransitionType.cupertino:
        return (context, animation, secondary, child) {
          final slide = animation.drive(Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: curve)));
          return SlideTransition(position: slide, child: child);
        };

      case TransitionType.cupertinoDialog:
        return (context, animation, secondary, child) {
          final scale = animation.drive(Tween<double>(begin: 1.1, end: 1.0).chain(CurveTween(curve: curve)));
          final fade = animation.drive(CurveTween(curve: curve));
          return FadeTransition(opacity: fade, child: ScaleTransition(scale: scale, child: child));
        };

      case TransitionType.native:
        return (context, animation, secondary, child) {
          final fade = animation.drive(CurveTween(curve: curve));
          final scale = animation.drive(Tween<double>(begin: 0.94, end: 1.0).chain(CurveTween(curve: curve)));
          return FadeTransition(opacity: fade, child: ScaleTransition(scale: scale, child: child));
        };

      case TransitionType.download:
        return (context, animation, secondary, child) {
          final drop = animation.drive(Tween<Offset>(begin: Offset(0, -1), end: Offset.zero).chain(CurveTween(curve: curve)));
          return SlideTransition(position: drop, child: child);
        };

      case TransitionType.uptown:
        return (context, animation, secondary, child) {
          final rise = animation.drive(Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: curve)));
          return SlideTransition(position: rise, child: child);
        };

      case TransitionType.topLevel:
        return (context, animation, secondary, child) {
          final scale = animation.drive(Tween<double>(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve)));
          final fade = animation.drive(CurveTween(curve: curve));
          return FadeTransition(opacity: fade, child: ScaleTransition(scale: scale, child: child));
        };
    }
  }
}


/// A stub implementation of GoRouter's `CustomTransitionPage` to avoid dependencies on go_router. Replace with the real import when needed.

class CustomTransitionPage<T> extends Page<T> {
  /// Constructor for a page with custom transition functionality.
  ///
  /// To be used instead of MaterialPage or CupertinoPage, which provide
  /// their own transitions.
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
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// The content to be shown in the Route created by this page.
  final Widget child;

  /// A duration argument to customize the duration of the custom page
  /// transition.
  ///
  /// Defaults to 300ms.
  final Duration transitionDuration;

  /// A duration argument to customize the duration of the custom page
  /// transition on pop.
  ///
  /// Defaults to 300ms.
  final Duration reverseTransitionDuration;

  /// Whether the route should remain in memory when it is inactive.
  ///
  /// If this is true, then the route is maintained, so that any futures it is
  /// holding from the next route will properly resolve when the next route
  /// pops. If this is not necessary, this can be set to false to allow the
  /// framework to entirely discard the route's widget hierarchy when it is
  /// not visible.
  final bool maintainState;

  /// Whether this page route is a full-screen dialog.
  ///
  /// In Material and Cupertino, being fullscreen has the effects of making the
  /// app bars have a close button instead of a back button. On iOS, dialogs
  /// transitions animate differently and are also not closeable with the
  /// back swipe gesture.
  final bool fullscreenDialog;

  /// Whether the route obscures previous routes when the transition is
  /// complete.
  ///
  /// When an opaque route's entrance transition is complete, the routes
  /// behind the opaque route will not be built to save resources.
  final bool opaque;

  /// Whether you can dismiss this route by tapping the modal barrier.
  final bool barrierDismissible;

  /// The color to use for the modal barrier.
  ///
  /// If this is null, the barrier will be transparent.
  final Color? barrierColor;

  /// The semantic label used for a dismissible barrier.
  ///
  /// If the barrier is dismissible, this label will be read out if
  /// accessibility tools (like VoiceOver on iOS) focus on the barrier.
  final String? barrierLabel;

  /// Override this method to wrap the child with one or more transition
  /// widgets that define how the route arrives on and leaves the screen.
  ///
  /// By default, the child (which contains the widget returned by buildPage) is
  /// not wrapped in any transition widgets.
  ///
  /// The transitionsBuilder method, is called each time the Route's state
  /// changes while it is visible (e.g. if the value of canPop changes on the
  /// active route).
  ///
  /// The transitionsBuilder method is typically used to define transitions
  /// that animate the new topmost route's comings and goings. When the
  /// Navigator pushes a route on the top of its stack, the new route's
  /// primary animation runs from 0.0 to 1.0. When the Navigator pops the
  /// topmost route, e.g. because the use pressed the back button, the primary
  /// animation runs from 1.0 to 0.0.
  final Widget Function(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) transitionsBuilder;

  @override
  Route<T> createRoute(BuildContext context) =>
      _CustomTransitionPageRoute<T>(this);
}

class _CustomTransitionPageRoute<T> extends PageRoute<T> {
  _CustomTransitionPageRoute(CustomTransitionPage<T> page)
      : super(settings: page);

  CustomTransitionPage<T> get _page => settings as CustomTransitionPage<T>;

  @override
  bool get barrierDismissible => _page.barrierDismissible;

  @override
  Color? get barrierColor => _page.barrierColor;

  @override
  String? get barrierLabel => _page.barrierLabel;

  @override
  Duration get transitionDuration => _page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _page.reverseTransitionDuration;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  bool get opaque => _page.opaque;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: _page.child,
      );

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) =>
      _page.transitionsBuilder(
        context,
        animation,
        secondaryAnimation,
        child,
      );
}

/// Custom transition page with no transition.
class NoTransitionPage<T> extends CustomTransitionPage<T> {
  /// Constructor for a page with no transition functionality.
  const NoTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
    transitionsBuilder: _transitionsBuilder,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );

  static Widget _transitionsBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) =>
      child;
}
