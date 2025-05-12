import 'package:custom_widgets_toolkit/src/widgets/custom_text.dart';
import 'package:flutter/material.dart';

/// A customizable elevated button with optional delay before triggering tap callbacks.
///
/// The [CustomElevatedButton] accepts an optional [delay] which is the duration the
/// button waits before executing its [onClick] or [onLongClick] callbacks. During this delay,
/// additional taps are ignored to prevent multiple triggers.
class CustomElevatedButton extends StatefulWidget {
  /// Text to be displayed on the button.
  /// This value is ignored if a [child] widget is provided.
  final String? label;

  /// A custom widget to display inside the button.
  final Widget? child;

  /// Background color for the button.
  final Color? backgroundColor;

  /// Elevation for the button's material.
  final double? elevation;

  /// Callback executed when the button is tapped.
  final void Function()? onClick;

  /// Callback executed when the button is long pressed.
  final void Function()? onLongClick;

  /// Border radius for rounded corners.
  final double? borderRadius;

  /// Font size for the label.
  final double? textSize;

  /// Explicit pixel height of the button.
  final double? pixelHeight;

  /// Explicit pixel width of the button.
  final double? pixelWidth;

  /// Height of the button as a percentage of screen height.
  final double? screenHeight;

  /// Width of the button as a percentage of screen width.
  final double? screenWidth;

  /// Color of the text displayed on the button.
  final Color? textColor;

  /// Border properties for the button.
  final BorderSide? side;

  /// Custom shape for the button's outline.
  final OutlinedBorder? shape;

  /// Color for the button's overlay (e.g. on press).
  final Color? overlayColor;

  /// Padding inside the button.
  final EdgeInsets? contentPadding;

  /// Whether the button is enabled.
  final bool enabled;

  /// Delay before triggering the callback.
  /// If set (e.g. Duration(milliseconds: 250)), the button waits for that duration
  /// before executing the callback. During the delay, further taps are ignored.
  final Duration delay;

  const CustomElevatedButton(
      {super.key,
      this.label,
      this.child,
      this.onClick,
      this.onLongClick,
      this.backgroundColor,
      this.elevation,
      this.borderRadius,
      this.textSize,
      this.pixelHeight,
      this.pixelWidth,
      this.screenHeight,
      this.screenWidth,
      this.textColor,
      this.side,
      this.shape,
      this.overlayColor,
      this.contentPadding,
      this.enabled = true,
      this.delay = Duration.zero});

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  // Flag to determine if a delay is currently in progress.
  // When true, any new taps are ignored.
  bool _isDelaying = false;

  /// Handles tap events (both normal and long press) with the specified delay.
  ///
  /// If the button is disabled, a delay is already in progress, or no callback is provided,
  /// the tap is ignored. Otherwise, it sets the [_isDelaying] flag, waits for the delay duration,
  /// then executes the callback and resets the flag.
  dynamic _handleTap(void Function()? callback) async {
    // Check if the button is enabled, not already delaying, and has a valid callback.
    if (!widget.enabled || _isDelaying || callback == null) return null;

    // Mark the button as in delaying state to ignore subsequent taps.
    if (widget.delay != Duration.zero) {
      setState(() {
        _isDelaying = true;
      });
      // Wait for the specified delay duration.
      await Future.delayed(widget.delay);
    }

    // If the widget is still in the widget tree, execute the callback.
    if (mounted) {
      callback();

      // Reset the delaying flag to allow new taps.
      if (_isDelaying != false) {
        setState(() {
          _isDelaying = false;
        });
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultBgColor = Colors.blueGrey;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: widget.screenWidth != null
          ? mediaQueryData.size.width * (widget.screenWidth! / 100)
          : widget.pixelWidth,
      height: widget.screenHeight != null
          ? mediaQueryData.size.height * (widget.screenHeight! / 100)
          : widget.pixelHeight,
      child: ElevatedButton(
        onPressed: (widget.enabled && widget.onClick != null)
            ? () => _handleTap(widget.onClick)
            : null,
        onLongPress: (widget.enabled && widget.onClick != null)
            ? () => _handleTap(widget.onLongClick)
            : null,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(widget.backgroundColor ??
              (widget.enabled ? defaultBgColor : Colors.grey)),
          padding: WidgetStatePropertyAll(widget.contentPadding ??
              EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)),
          overlayColor: WidgetStatePropertyAll(
              widget.overlayColor ?? Colors.blueGrey.withAlpha(100)),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: WidgetStatePropertyAll(widget.elevation),
          shape: WidgetStatePropertyAll(widget.shape ??
              RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 8.0))),
          side: WidgetStatePropertyAll(widget.side),
          minimumSize: const WidgetStatePropertyAll(Size(4, 4)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: widget.child ??
            Center(
                child: CustomText(
              widget.label ?? "button",
              fontSize: widget.textSize ?? 12,
              color: widget.textColor,
              invertColor: true,
            )),
      ),
    );
  }
}
