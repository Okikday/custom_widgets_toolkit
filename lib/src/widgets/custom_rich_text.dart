import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final List<CustomTextSpan>? textSpans;
  final TextAlign? align;
  final TextOverflow overflow;
  final int? maxLines;

  const CustomRichText({
    super.key,
    required this.textSpans,
    this.align,
    this.overflow = TextOverflow.visible,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: textSpans?.map((customTextSpan) {
          // Wrap the widget in a WidgetSpan so it can be used in a RichText.
          return WidgetSpan(child: customTextSpan);
        }).toList(),
      ),
      textAlign: align ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}


class CustomTextSpan extends StatelessWidget {
  final String data;
  final double fontSize;
  final double adjustSize;
  final Color? color;
  final Color? darkColor;
  final TextAlign? align;
  final bool invertColor;
  final TextOverflow? overflow;
  final String? fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;
  final Color decorationColor;
  final List<Shadow> shadows;
  final double? height;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextDecorationStyle? decorationStyle;
  final bool? softWrap;
  final int? maxLines;
  final TextStyle? style;
  final Color? backgroundColor;
  final List<String>? fontFamilyFallback;
  final List<FontFeature>? fontFeatures;
  final List<FontVariation>? fontVariations;
  final TextLeadingDistribution? leadingDistribution;
  final String? package;
  final TextBaseline? textBaseline;
  final double? decorationThickness;
  final String? debugLabel;

  const CustomTextSpan(
    this.data, {
    super.key,
    this.fontSize = 12.0,
    this.adjustSize = 0.0,
    this.color,
    this.darkColor,
    this.align,
    this.invertColor = false,
    this.overflow,
    this.fontFamily,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.textDecoration = TextDecoration.none,
    this.decorationColor = Colors.black,
    this.shadows = const [],
    this.height,
    this.letterSpacing,
    this.wordSpacing,
    this.decorationStyle,
    this.softWrap,
    this.maxLines,
    this.style,
    this.backgroundColor,
    this.fontFamilyFallback,
    this.fontFeatures,
    this.fontVariations,
    this.leadingDistribution,
    this.package,
    this.textBaseline,
    this.decorationThickness,
    this.debugLabel,
  });

  /// Computes the final TextStyle
  TextStyle effectiveStyle(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    Color resolvedColor = color ??
        (isDarkMode
            ? (invertColor ? Colors.black : Colors.white)
            : (invertColor ? Colors.white : Colors.black));
    if (darkColor != null && isDarkMode) {
      resolvedColor = darkColor!;
    }

    return style ??
        TextStyle(
          color: resolvedColor,
          fontSize: fontSize + adjustSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: textDecoration,
          decorationColor: decorationColor,
          shadows: shadows,
          height: height,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          decorationStyle: decorationStyle,
          backgroundColor: backgroundColor,
          fontFamilyFallback: fontFamilyFallback,
          fontFeatures: fontFeatures,
          fontVariations: fontVariations,
          leadingDistribution: leadingDistribution,
          package: package,
          textBaseline: textBaseline,
          decorationThickness: decorationThickness,
          debugLabel: debugLabel,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: effectiveStyle(context),
      textAlign: align,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
    );
  }
}
