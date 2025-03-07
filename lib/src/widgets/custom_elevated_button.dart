import 'package:custom_widgets_toolkit/src/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final Color? backgroundColor;
  final double? elevation;
  final void Function()? onClick;
  final void Function()? onLongClick;
  final double? borderRadius;
  final double? textSize;
  final double? pixelHeight;   // Use pixel height for the normal height, declare for pixel if you want more customization over size
  final double? pixelWidth;   // .... width for the normal width
  final double? screenHeight;   // Use this for height with respect to the screen size
  final double? screenWidth;
  final Color? textColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Color? overlayColor;
  final EdgeInsets? contentPadding;

  const CustomElevatedButton({
    super.key,
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
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultBgColor = Colors.blueGrey;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Color primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      width: screenWidth != null ? mediaQueryData.size.width * (screenWidth! / 100) : pixelWidth,
      height: screenHeight != null ? mediaQueryData.size.height * (screenHeight! / 100) : pixelHeight,
      child: ElevatedButton(
          onPressed: onClick,
          onLongPress: onLongClick,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(backgroundColor ?? defaultBgColor),
            padding: WidgetStatePropertyAll(contentPadding ?? EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)),
            overlayColor: WidgetStatePropertyAll(overlayColor ?? primaryColor.withValues(alpha: 20)),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            elevation: WidgetStatePropertyAll(elevation),
            shape: WidgetStatePropertyAll(shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 8.0) )),
            side: WidgetStatePropertyAll(side),
            minimumSize: const WidgetStatePropertyAll(Size(4, 4)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child ?? Center(
            child: CustomText(label ?? "button", fontSize: textSize ?? 12, color: textColor, invertColor: true,)
          ),
          ),
    );
  }
}