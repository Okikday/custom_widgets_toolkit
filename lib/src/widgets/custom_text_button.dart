import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final Widget? icon; // Optional icon
  final Color? backgroundColor;
  final VoidCallback? onClick;
  final VoidCallback? onLongClick;
  final double? borderRadius;
  final double? textSize;
  final double? pixelHeight; // Height in pixels
  final double? pixelWidth; // Width in pixels
  final double? screenHeight; // Height as a percentage of screen height
  final double? screenWidth; // Width as a percentage of screen width
  final Color? textColor;
  final EdgeInsets? contentPadding;
  final double? iconSpacing; // Optional spacing between icon and label

  const CustomTextButton({
    super.key,
    this.label,
    this.child,
    this.icon,
    this.onClick,
    this.onLongClick,
    this.backgroundColor,
    this.borderRadius,
    this.textSize,
    this.pixelHeight,
    this.pixelWidth,
    this.screenHeight,
    this.screenWidth,
    this.textColor,
    this.contentPadding,
    this.iconSpacing,
  });

  @override
  Widget build(BuildContext context) {
    // Define the button style.
    final ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor:
          WidgetStatePropertyAll(backgroundColor ?? Colors.transparent),
      padding: WidgetStatePropertyAll(contentPadding),
      overlayColor: WidgetStatePropertyAll(Colors.blue.withAlpha(26)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 24),
        ),
      ),
      minimumSize: WidgetStatePropertyAll(const Size(4, 4)),
    );

    // Determine the content for the button.
    Widget buttonContent;
    if (child != null) {
      buttonContent = child!;
    } else if (label != null) {
      buttonContent = Center(
        child: Text(
          label!,
          style: TextStyle(
            fontSize: textSize ?? 16,
            color: textColor ?? Colors.black,
          ),
        ),
      );
    } else {
      buttonContent = const SizedBox.shrink();
    }

    // Create the button widget: use TextButton.icon if an icon is provided.
    Widget button;
    if (icon != null && (label != null || child != null)) {
      // Note: TextButton.icon places the icon before the label by default.
      // To adjust spacing, you can wrap the label in a Padding widget if needed.
      button = TextButton.icon(
        onPressed: onClick,
        onLongPress: onLongClick,
        style: buttonStyle,
        icon: icon!,
        label: buttonContent,
      );
    } else {
      button = TextButton(
        onPressed: onClick,
        onLongPress: onLongClick,
        style: buttonStyle,
        child: buttonContent,
      );
    }

    return SizedBox(
      width: screenWidth != null
          ? MediaQuery.of(context).size.width * (screenWidth! / 100)
          : pixelWidth,
      height: screenHeight != null
          ? MediaQuery.of(context).size.height * (screenHeight! / 100)
          : pixelHeight,
      child: button,
    );
  }
}
