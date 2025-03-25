import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';

/// An enumeration that defines the visual style (or "vibe") for the SnackBar.
///
/// This enum is used to determine the color scheme and icon for the custom SnackBar.
///
enum SnackBarVibe {
  error,
  success,
  warning,
  none,
  info,
}

/// A helper class that provides a method to display a custom-styled SnackBar.
///
/// The [CustomSnackBar] class adapts its appearance based on the current theme
/// (light or dark) and the selected [SnackBarVibe]. It supports optional parameters
/// for further customization such as background color, text style, icon, content widget,
/// dismiss direction, shape, and duration.
class CustomSnackBar {
  /// Displays a custom SnackBar with the specified [content] and [vibe].
  ///
  /// The SnackBar will automatically adjust its colors based on the current theme (light/dark).
  ///
  /// **Parameters:**
  /// - [context]: The BuildContext in which to display the SnackBar.
  /// - [content]: The text message to be displayed inside the SnackBar.
  /// - [vibe]: The visual style for the SnackBar (error, neutral, success, warning). Defaults to [SnackBarVibe.neutral].
  /// - [backgroundColor]: Optional. Overrides the default background color.
  /// - [textStyle]: Optional. Custom text style for the content. Defaults to a style using the main vibe color and a font size of 16.
  /// - [icon]: Optional. Custom widget to display as the icon. If not provided, a default icon based on [vibe] is used.
  /// - [contentWidget]: Optional. If provided, replaces the default layout (a [Row] containing the text and icon).
  /// - [dismissDirection]: Optional. Determines the direction in which the SnackBar can be dismissed.
  ///   Defaults to [DismissDirection.vertical].
  /// - [shape]: Optional. Defines the shape of the SnackBar. Defaults to a [RoundedRectangleBorder] with a stadium border.
  /// - [duration]: Optional. Specifies the duration for which the SnackBar is visible.
  ///   Defaults to 2000 milliseconds.
  static void showSnackBar(BuildContext context,
      {required String content,
      SnackBarVibe vibe = SnackBarVibe.none,
      Color? backgroundColor,
      TextStyle? textStyle,
      Widget? icon,
      Widget? prefixIcon,
      Widget? contentWidget,
      DismissDirection? dismissDirection,
      ShapeBorder? shape,
      Duration? duration,
      EdgeInsets? margin,
      bool usePrimaryColor = false,
      bool? showCloseIcon,
      EdgeInsets? padding,
      double? width,
      Color? borderColor}) {
    final Map<SnackBarVibe, Color> mainColors = {
      SnackBarVibe.none: Colors.blueGrey.shade800,
      SnackBarVibe.info: Colors.lightBlue.shade800,
      SnackBarVibe.error: const Color(0xfff30d0d),
      SnackBarVibe.success: const Color(0xff00ff00),
      SnackBarVibe.warning: const Color(0xFFF46B22),
    };

    final Map<SnackBarVibe, Color> backgroundColors = {
      for (final vibe in SnackBarVibe.values)
        vibe: mainColors[vibe]!.withValues(alpha: 0.2)
    };

    final Map<SnackBarVibe, IconData> icons = {
      SnackBarVibe.none: Icons.info_outline_rounded,
      SnackBarVibe.info: Icons.info_outline_rounded,
      SnackBarVibe.error: Icons.error_outline_rounded,
      SnackBarVibe.success: Icons.check_circle_outline_rounded,
      SnackBarVibe.warning: Icons.warning_amber_rounded,
    };

    // Choose colors based on whether dark mode is active.
    final Color mainColor = mainColors[vibe]!;
    final Color bgColor = backgroundColors[vibe]!;
    final IconData iconData = icons[vibe]!;

    final ThemeData themeData = Theme.of(context);
    final bool isDarkMode = themeData.brightness == Brightness.dark;
    final Color primaryColor = themeData.primaryColor;
    final Color scaffoldBackgroundColor = themeData.scaffoldBackgroundColor;

    // Remove any currently visible SnackBar.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the custom SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: showCloseIcon,
        width: width,
        padding: padding,
        behavior:
            SnackBarBehavior.floating, // Makes the SnackBar float above the UI.
        duration: duration ?? const Duration(milliseconds: 2000),
        margin:
            margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: backgroundColor ??
            (usePrimaryColor && vibe == SnackBarVibe.none
                ? primaryColor.withValues(alpha: 0.3)
                : vibe == SnackBarVibe.none
                    ? (scaffoldBackgroundColor.withValues(alpha: 0.25))
                    : bgColor),
        dismissDirection: dismissDirection ?? DismissDirection.vertical,
        elevation: 48,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                  color: borderColor ??
                      (backgroundColor?.withValues(alpha: 0.75) ??
                          (usePrimaryColor && vibe == SnackBarVibe.none
                              ? primaryColor.withValues(alpha: 0.75)
                              : vibe == SnackBarVibe.none
                                  ? (scaffoldBackgroundColor.withValues(
                                      alpha: 0.75))
                                  : bgColor.withValues(alpha: 0.75))),
                  width: 1),
            ),
        content: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: contentWidget ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) prefixIcon,
                  // Expanded widget ensures the text takes up available space.
                  Expanded(
                    child: CustomText(
                      content,
                      style: textStyle ??
                          TextStyle(
                            color: vibe == SnackBarVibe.none
                                ? (isDarkMode ? Colors.black : Colors.white)
                                : mainColor,
                            fontSize: 16,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  icon ??
                      Icon(
                        iconData,
                        color: vibe == SnackBarVibe.none
                            ? (isDarkMode ? Colors.black : Colors.white)
                            : mainColor,
                      ),
                ],
              ),
        ),
      ),
    );
  }
}
