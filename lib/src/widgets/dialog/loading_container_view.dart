
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';

/// LoadingContainerView
class LoadingContainerView extends StatelessWidget {
  const LoadingContainerView(
      {super.key,
      this.msg = "Just a moment...",
      this.msgTextStyle,
      this.backgroundColor,
      this.adaptToScreenSize = false,
      this.progressIndicatorColor});
  final String? msg;
  final TextStyle? msgTextStyle;
  final Color? backgroundColor;
  final bool adaptToScreenSize;
  final Color? progressIndicatorColor;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final ThemeData themeData = Theme.of(context);
    final primaryColor = themeData.primaryColor;
    final isDarkMode = themeData.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.center,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDarkMode ? Colors.black : Colors.white),
          borderRadius: BorderRadius.circular(36),
          border: Border.fromBorderSide(BorderSide(color: Colors.blueGrey.withValues(alpha: 0.05))),
          boxShadow: [
            BoxShadow(
              offset: Offset.zero,
              blurRadius: 4.0,
              spreadRadius: 2.0,
              color: Colors.blueGrey.withValues(alpha: 0.2),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: SizedBox(
          width: adaptToScreenSize ? screenWidth * 0.6 : 240,
          height: adaptToScreenSize ? screenWidth * 0.4 : 160,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    color: progressIndicatorColor ?? primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: CustomText(
                    msg!,
                    color: msgTextStyle == null ? Colors.blueGrey : msgTextStyle?.color,
                    fontSize: msgTextStyle == null ? 14 : msgTextStyle!.fontSize!,
                    style: msgTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
