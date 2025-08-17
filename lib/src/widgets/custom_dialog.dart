import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:custom_widgets_toolkit/src/widgets/dialog/emulated_dialog.dart';
import 'package:custom_widgets_toolkit/src/widgets/dialog/loading_container_view.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  // Static reference to the current route.
  static PageRoute? _currentRoute;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool canPop = true,
    Duration transitionDuration = Durations.medium4,
    Duration reverseTransitionDuration = Durations.medium2,

    /// Use CustomCurves to prevent unexpected behavior
    Curve? curve,
    Offset? blurSigma,
    Color? barrierColor,
    TransitionType transitionType = TransitionType.fade,
    bool opaque = false,
    bool fullscreenDialog = false,
  }) {
    final scaffold = EmulatedDialog(
        canPop: canPop,
        blurSigma: blurSigma,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        curve: curve ?? CustomCurves.decelerate,
        barrierColor: barrierColor,
        child: child);
    final pageRoute = PageAnimation.pageRouteBuilder(
      scaffold,
      type: transitionType,
      duration: transitionDuration,
      reverseDuration: reverseTransitionDuration,
      opaque: opaque,
      fullscreenDialog: fullscreenDialog
    );

    _currentRoute = pageRoute;

    // Push the route and clear the stored reference once it completes.
    return Navigator.of(context).push<T>(pageRoute as Route<T>).whenComplete(() {
      _currentRoute = null;
    });
  }

  /// Shows the loading dialog by pushing a custom route using [loadingDialogBuilder].
  /// It now takes the [BuildContext] as a required parameter.
  static Future<T?> showLoadingDialog<T>(
    BuildContext context, {
    String msg = "Just a moment...",
    Color? msgTextColor,
    double? msgTextSize,
    TextStyle? msgTextStyle,
    bool canPop = true,
    Color? backgroundColor,
    Color? progressIndicatorColor,
    Duration transitionDuration = Durations.medium4,
    Duration reverseTransitionDuration = Durations.medium2,

    /// Use CustomCurves to prevent unexpected behavior
    Curve? curve,

    /// For non-animatedDialog
    bool adaptToScreenSize = false,
    Offset? blurSigma,
    Color? barrierColor,
    TransitionType transitionType = TransitionType.fade,
  }) {
    final scaffold = EmulatedDialog(
      canPop: canPop,
      blurSigma: blurSigma,
      adaptToScreenSize: adaptToScreenSize,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      curve: curve ?? CustomCurves.decelerate,
      barrierColor: barrierColor,
      child: LoadingContainerView(
        msg: msg,
        msgTextStyle: msgTextStyle ??
            msgTextStyle?.copyWith(
              color: msgTextColor,
              fontSize: msgTextSize,
            ),
        backgroundColor: backgroundColor,
        adaptToScreenSize: adaptToScreenSize,
        progressIndicatorColor: progressIndicatorColor,
      ),
    );

    final pageRoute = PageAnimation.pageRouteBuilder(
      scaffold,
      type: transitionType,
      duration: transitionDuration,
      reverseDuration: reverseTransitionDuration,
      opaque: false,
    );

    // Store the route reference.
    _currentRoute = pageRoute;

    // Push the route and clear the stored reference once it completes.
    return Navigator.of(context).push<T>(pageRoute as Route<T>).whenComplete(() {
      _currentRoute = null;
    });
  }

  /// Hides the dialog by popping the current route if it exists.
  /// If the dialog has already been popped or the context is no longer valid,
  /// this function will do nothing.

  static void hide(BuildContext context) {
    if (_currentRoute != null) {
      // Check if the Navigator can pop before calling pop.
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _currentRoute = null;
    }
  }

  static const loadingMessages = [
    "Just a moment...",
    "Please wait...",
    "Hold on...",
    "Loading, please wait...",
    "Hang tight...",
    "Almost there...",
    "Still with us? Just fine-tuning things...",
    "One moment please...",
    "Just a sec...",
    "Processing your request...",
    "Please hold on...",
    "Working on it...",
    "Stay with us...",
    "We're getting there...",
    "Give us a second...",
    "Waiting for things to load...",
    "Getting everything ready...",
    "Loading, please be patient...",
    "Please stand by...",
    "Getting things in order...",
    "Thank you for your patience...",
    "Just a little bit longer...",
    "Preparing your content...",
    "Completing tasks...",
    "We're almost ready...",
    "Almost done...",
    "Patience, we're on it...",
    "Wait just a little longer...",
    "Getting things set up...",
    "Hang on, loading now...",
  ];
}
