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
      }) {
    // Automatically determine dark mode based on the current theme.
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Map each vibe to a main color, a light background color, and an icon.
    final Map<SnackBarVibe, Color> mainColors = {
      SnackBarVibe.none: Colors.grey.shade800,
      SnackBarVibe.info: Colors.lightBlue.shade600,
      SnackBarVibe.error: Colors.red.shade400,
      SnackBarVibe.neutral: Colors.blueGrey,
      SnackBarVibe.success: Colors.green.shade600,
      SnackBarVibe.warning: Colors.orange.shade600,
    };

    final Map<SnackBarVibe, Color> backgroundColors = {
      SnackBarVibe.none: Colors.grey.shade50,
      SnackBarVibe.info: Colors.lightBlue.shade50,
      SnackBarVibe.error: Colors.red.shade50,
      SnackBarVibe.neutral: Colors.blueGrey.shade50,
      SnackBarVibe.success: Colors.green.shade50,
      SnackBarVibe.warning: Colors.orange.shade50,
    };

    // Dark mode color maps.
    final Map<SnackBarVibe, Color> mainColorsDarkMode = {
      SnackBarVibe.error: Colors.red.shade300,
      SnackBarVibe.neutral: Colors.blueGrey.shade300,
      SnackBarVibe.success: Colors.green.shade300,
      SnackBarVibe.warning: Colors.orange.shade300,
    };

    final Map<SnackBarVibe, Color> backgroundColorsDarkMode = {
      SnackBarVibe.none: Colors.white,
      SnackBarVibe.info: Colors.lightBlue.shade300,
      SnackBarVibe.error: Colors.red.shade300,
      SnackBarVibe.neutral: Colors.blueGrey.shade300,
      SnackBarVibe.success: Colors.green.shade300,
      SnackBarVibe.warning: Colors.orange.shade300,

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
    final Color mainColor =
    isDarkMode ? mainColorsDarkMode[vibe]! : mainColors[vibe]!;
    final Color bgColor = isDarkMode
        ? backgroundColorsDarkMode[vibe]!
        : backgroundColors[vibe]!;
    final IconData iconData = icons[vibe]!;

    // Remove any currently visible SnackBar.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the custom SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating, // Makes the SnackBar float above the UI.
        duration: duration ?? const Duration(milliseconds: 2000),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: backgroundColor ?? bgColor,
        dismissDirection: dismissDirection ?? DismissDirection.vertical,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: mainColor, width: 1),
            ),
        content: contentWidget ??
            Row(
              mainAxisSize: MainAxisSize.max,
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
    );
  }
}
