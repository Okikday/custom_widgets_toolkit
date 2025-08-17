import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A data-class that holds text and style properties.
/// It can be converted into a regular [TextSpan] using a provided base style.
class CustomTextSpanData {
  final String data;
  final double fontSize;
  final double adjustSize;
  final Color? color;
  final Color? darkColor;
  final bool invertColor;
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
  final TapGestureRecognizer? recognizer;
  final List<CustomTextSpanData>? children;
  final MouseCursor? mouseCursor;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final String? semanticsLabel;
  final bool? spellOut;
  final Locale? locale;
  final TextOverflow? overflow;

  CustomTextSpanData(
    this.data, {
    this.fontSize = 12.0,
    this.adjustSize = 0.0,
    this.color,
    this.darkColor,
    this.invertColor = false,
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
    this.recognizer,
    this.children,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.semanticsLabel,
    this.spellOut,
    this.locale,
    this.overflow,
  });

  /// Converts this data object into a [TextSpan].
  /// The provided [baseStyle] (typically obtained via DefaultTextStyle) is used
  /// as the foundation if no [style] is explicitly set.
  TextSpan toTextSpan(TextStyle baseStyle) {
    // Determine dark mode without requiring a context.
    final bool isDarkMode =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    Color resolvedColor = color ??
        (isDarkMode
            ? (invertColor ? Colors.black : Colors.white)
            : (invertColor ? Colors.white : Colors.black));
    if (darkColor != null && isDarkMode) {
      resolvedColor = darkColor!;
    }

    final effectiveStyle = style ??
        baseStyle.copyWith(
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

    return TextSpan(
      text: data,
      style: effectiveStyle,
      recognizer: recognizer,
      onEnter: onEnter,
      onExit: onExit,
      locale: locale,
      mouseCursor: mouseCursor,
      spellOut: spellOut,
      semanticsLabel: semanticsLabel,
      children: children?.map((child) => child.toTextSpan(baseStyle)).toList(),
    );
  }
}

/// A RichText widget that accepts a list of either [CustomTextSpanData] or any [InlineSpan],
/// such as a [WidgetSpan].
class CustomRichText extends StatelessWidget {
  /// The list may contain instances of [CustomTextSpanData] (which will be converted
  /// to a [TextSpan]) or any other [InlineSpan] (such as a [WidgetSpan]).
  final List<Object> children;
  final TextOverflow overflow;
  final int? maxLines;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextScaler textScaler;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final SelectionRegistrar? selectionRegistrar;
  final Color? selectionColor;
  final TapGestureRecognizer? recognizer;
  final MouseCursor? mouseCursor;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final TextStyle? style;
  final bool? spellOut;

  const CustomRichText(
      {super.key,
      required this.children,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.visible,
      this.maxLines,
      this.textDirection,
      this.softWrap = true,
      this.textScaler = TextScaler.noScaling,
      this.locale,
      this.strutStyle,
      this.textWidthBasis = TextWidthBasis.parent,
      this.textHeightBehavior,
      this.selectionRegistrar,
      this.selectionColor,
      this.recognizer,
      this.mouseCursor,
      this.onEnter,
      this.onExit,
      this.style,
      this.spellOut});

  @override
  Widget build(BuildContext context) {
    // Use the default text style from the context.
    final baseStyle = DefaultTextStyle.of(context).style;
    // Convert each item in children to an InlineSpan if needed.
    final inlineSpans = children.map<InlineSpan>((child) {
      if (child is CustomTextSpanData) {
        return child.toTextSpan(baseStyle);
      } else if (child is InlineSpan) {
        return child;
      } else {
        throw Exception(
            'Children must be either CustomTextSpanData or InlineSpan');
      }
    }).toList();

    return RichText(
      text: TextSpan(
          children: inlineSpans,
          style: style,
          onEnter: onEnter,
          onExit: onExit,
          mouseCursor: mouseCursor,
          locale: locale,
          recognizer: recognizer,
          spellOut: spellOut),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      textDirection: textDirection,
      softWrap: softWrap,
      textScaler: textScaler,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionRegistrar: selectionRegistrar,
      selectionColor: selectionColor,
    );
  }
}
