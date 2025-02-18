import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';

/// An enumeration that defines the visual style (or "vibe") for the SnackBar.
///
/// This enum is used to determine the color scheme and icon for the custom SnackBar.
/// 
enum SnackBarVibe {
  error,
  neutral,
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
  static void showSnackBar(
      BuildContext context, {
        required String content,
        SnackBarVibe vibe = SnackBarVibe.neutral,
        Color? backgroundColor,
        TextStyle? textStyle,
        Widget? icon,
        Widget? contentWidget,
        DismissDirection? dismissDirection,
        ShapeBorder? shape,
        Duration? duration,
        EdgeInsets? margin
      }) {


    final Map<SnackBarVibe, Color> mainColors = {
      SnackBarVibe.none: Colors.grey.shade800,
      SnackBarVibe.info: Colors.lightBlue.shade800,
      SnackBarVibe.error: Colors.red.shade800,
      SnackBarVibe.neutral: Colors.blueGrey.shade800,
      SnackBarVibe.success: Colors.green.shade800,
      // Use the provided pumpkin color for warning
      SnackBarVibe.warning: const Color(0xFFF46B22),
    };

    final Map<SnackBarVibe, Color> backgroundColors = {
      // For every vibe, border is mainColor with 20% opacity.
      for (final vibe in SnackBarVibe.values)
        vibe: mainColors[vibe]!.withValues(alpha: 0.05),
    };

    final Map<SnackBarVibe, Color> borderColors = {
      // For every vibe, border is mainColor with 20% opacity.
      for (final vibe in SnackBarVibe.values)
        vibe: mainColors[vibe]!.withValues(alpha: 0.2),
    };



    final Map<SnackBarVibe, IconData> icons = {
      SnackBarVibe.none: Icons.remove_circle_outline,
      SnackBarVibe.info: Icons.info,
      SnackBarVibe.error: Icons.error_outline,
      SnackBarVibe.neutral: Icons.info_outline,
      SnackBarVibe.success: Icons.check_circle_outline,
      SnackBarVibe.warning: Icons.warning_amber_outlined,
    };

    // Choose colors based on whether dark mode is active.
    final Color mainColor = mainColors[vibe]!;
    final Color bgColor = backgroundColors[vibe]!;
    final IconData iconData = icons[vibe]!;

    // Remove any currently visible SnackBar.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the custom SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating, // Makes the SnackBar float above the UI.
        duration: duration ?? const Duration(milliseconds: 2000),
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: backgroundColor ?? bgColor,
        dismissDirection: dismissDirection ?? DismissDirection.vertical,
        elevation: 0,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: borderColors[vibe]!, width: 1),
            ),
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: contentWidget ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Expanded widget ensures the text takes up available space.
                  Expanded(
                    child: CustomText(
                      content,
                      style: textStyle ??
                          TextStyle(
                            color: mainColor,
                            fontSize: 16,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    iconData,
                    color: mainColor,
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
