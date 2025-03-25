import 'package:flutter/material.dart';

/// A customizable text widget that extends Flutter's default [Text] widget
/// with advanced styling and dynamic color handling.
///
/// The [CustomText] widget offers extended control over text appearance by
/// providing a wide range of customizable parameters. It is designed to adapt
/// to dark mode automatically (using [darkColor] and [invertColor]) and allows
/// for fine‑tuning of typography including font size, weight, style, decorations,
/// shadows, and more.
///
/// The effective text style is computed in the [effectiveStyle] method. This method
/// takes into account the current platform brightness to adjust the text color,
/// optionally using [darkColor] if the device is in dark mode. Additionally, if
/// [invertColor] is set to true, the widget swaps between light and dark colors.
///
/// ## Customization Options
///
/// - **Text Content:**
///   The text to display is provided as the [data] parameter.
///
/// - **Font Size and Adjustment:**
///   Use [fontSize] to set the base size of the text and [adjustSize] to add a
///   further adjustment (e.g. for dynamic scaling).
///
/// - **Color Handling:**
///   [color] sets the default text color; [darkColor] overrides [color] in dark mode.
///   If [invertColor] is true, the widget uses the opposite of the expected color
///   based on the current brightness.
///
/// - **Typography:**
///   Customize the text using [fontFamily], [fontWeight], [fontStyle], and [fontFamilyFallback].
///
/// - **Text Decorations:**
///   Control underlines, overlines, etc., with [textDecoration], [decorationColor],
///   and [decorationStyle]. [decorationThickness] also allows you to adjust the thickness.
///
/// - **Spacing and Shadows:**
///   Use [letterSpacing] and [wordSpacing] for spacing adjustments, and [shadows] to add drop shadows.
///
/// - **Layout Options:**
///   The widget accepts parameters such as [height] for line height, [backgroundColor],
///   [inputContentPadding] (if used in a similar context), and more advanced typography
///   features like [fontFeatures], [fontVariations], and [leadingDistribution].
///
/// - **Additional Styling:**
///   Optional parameters like [selectionColor], [strutStyle], [textAlign], [textDirection],
///   [locale], [textScaleFactor], and [textScaler] offer further control over text rendering.
///
/// - **Miscellaneous:**
///   Other parameters like [package], [debugLabel], and [semanticsLabel] provide additional
///   customization and accessibility support.
///
/// ## Example Usage
///
/// ```dart
/// CustomText(
///   "Hello, World!",
///   fontSize: 16,
///   adjustSize: 2,
///   color: Colors.black,
///   darkColor: Colors.white,
///   invertColor: false,
///   fontWeight: FontWeight.bold,
///   textDecoration: TextDecoration.underline,
/// )
/// ```
///
/// If the [style] parameter is provided, it will be used as-is. Otherwise, the widget computes
/// a default style using the provided customization parameters.
class CustomText extends StatelessWidget {
  /// The text content to display.
  final String data;

  /// The base font size.
  final double fontSize;

  /// A value added to [fontSize] for further adjustment.
  final double adjustSize;

  /// The default text color.
  final Color? color;

  /// The text color to use in dark mode.
  final Color? darkColor;

  /// If true, the text color is inverted (e.g. dark becomes light and vice versa).
  final bool invertColor;

  /// How overflowing text should be handled.
  final TextOverflow? overflow;

  /// The name of the font family.
  final String? fontFamily;

  /// The weight of the font.
  final FontWeight fontWeight;

  /// The style of the font (normal or italic).
  final FontStyle fontStyle;

  /// Decoration (underline, overline, etc.) for the text.
  final TextDecoration textDecoration;

  /// The color of the text decoration.
  final Color decorationColor;

  /// Shadows to apply behind the text.
  final List<Shadow> shadows;

  /// The line height as a multiple of the font size.
  final double? height;

  /// The space between letters.
  final double? letterSpacing;

  /// The space between words.
  final double? wordSpacing;

  /// The style of the text decoration (solid, double, dotted, dashed, wavy).
  final TextDecorationStyle? decorationStyle;

  /// If true, text will wrap softly.
  final bool? softWrap;

  /// The maximum number of lines to display.
  final int? maxLines;

  /// A complete [TextStyle] that overrides all other style parameters.
  final TextStyle? style;

  /// The background color for the text.
  final Color? backgroundColor;

  /// Fallback font families to use if [fontFamily] is not available.
  final List<String>? fontFamilyFallback;

  /// Font features (such as small caps).
  final List<FontFeature>? fontFeatures;

  /// Variations for variable fonts.
  final List<FontVariation>? fontVariations;

  /// The distribution of line heights.
  final TextLeadingDistribution? leadingDistribution;

  /// The package where the font is located.
  final String? package;

  /// The baseline to use for aligning text.
  final TextBaseline? textBaseline;

  /// The thickness of any text decoration.
  final double? decorationThickness;

  /// A label for debugging purposes.
  final String? debugLabel;

  /// How the text should be adjusted vertically.
  final TextHeightBehavior? textHeightBehavior;

  /// A semantic label for accessibility.
  final String? semanticsLabel;

  /// How the width of the text should be measured.
  final TextWidthBasis? textWidthBasis;

  /// The color of text selection.
  final Color? selectionColor;

  /// The style of the strut (vertical spacing).
  final StrutStyle? strutStyle;

  /// How the text is aligned horizontally.
  final TextAlign? textAlign;

  /// The direction in which text flows.
  final TextDirection? textDirection;

  /// The locale used to render the text.
  final Locale? locale;

  /// The scaling factor for the text.
  final double? textScaleFactor;

  /// A custom text scaler.
  final TextScaler? textScaler;

  /// Creates a [CustomText] widget with advanced customization options.

  const CustomText(
    this.data, {
    super.key,
    this.fontSize = 14.0,
    this.adjustSize = 0.0,
    this.color,
    this.darkColor,
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
    this.textHeightBehavior,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.textScaleFactor,
    this.textScaler,
  });

  /// Computes and returns the effective [TextStyle] for this widget.
  ///
  /// This method calculates the final style by combining the provided parameters,
  /// taking into account the current platform brightness. If no [style] is provided,
  /// a default style is computed. In dark mode, [darkColor] (if specified) is used.
  TextStyle effectiveStyle(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    Color resolvedColor = color ??
        (isDarkMode
            ? (invertColor ? Colors.black : Colors.white)
            : (invertColor ? Colors.white : Colors.black));
    if (darkColor != null && isDarkMode) resolvedColor = darkColor!;

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
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
      textHeightBehavior: textHeightBehavior,
      semanticsLabel: semanticsLabel,
      selectionColor: selectionColor,
      locale: locale,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textScaler: textScaler,
      textWidthBasis: textWidthBasis,
    );
  }
}
