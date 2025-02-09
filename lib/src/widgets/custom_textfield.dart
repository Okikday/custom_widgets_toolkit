import 'package:custom_widgets_toolkit/src/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable text field widget that provides advanced styling and behavior options.
/// 
/// The [CustomTextfield] widget wraps a [TextField] with extended customization such as:
/// 
/// - **Custom Sizing:** Supports fixed pixel dimensions or screen-relative sizes.
/// - **Custom Styling:** Allows control over borders, background color, text styles, etc.
/// - **Icon Support:** Supports optional prefix and suffix icons. The suffix icon can be conditionally
///   displayed based on the focus and text input state.
/// - **Automatic Resource Management:** Automatically creates and disposes of a [TextEditingController]
///   and a [FocusNode] if they are not provided.
/// - **Event Callbacks:** Provides callbacks for tap, tap outside, on changed, on submitted, and on
///   editing complete events.
/// - **Advanced Input Control:** Supports input formatters, maximum length, cursor customization, and more.
/// 
/// ## Example Usage
///
/// ```dart
/// CustomTextfield(
///   hint: 'Enter your name',
///   label: 'Name',
///   pixelHeight: 48,
///   pixelWidth: 300,
///   backgroundColor: Colors.white,
///   borderRadius: 12,
///   suffixIcon: Icon(Icons.clear),
///   onchanged: (text) => print("Current input: $text"),
/// )
/// ```
/// 
/// If you need to listen to changes in the suffix icon visibility, consider using a 
/// `ValueNotifier` and a `ValueListenableBuilder` as demonstrated in the implementation.
/// 
/// Note: When using this widget in a stateful context, the widget manages its internal state
/// (such as the suffix icon visibility) and rebuilds appropriately when those values change.

/// A [StatefulWidget] that wraps a [TextField] with extended customization options.
///
/// This widget automatically manages its own [TextEditingController] and [FocusNode] if they
/// are not provided via constructor parameters. It also handles conditional display of the suffix
/// icon based on whether the text field is focused and non-empty, unless overridden by the
/// [alwaysShowSuffixIcon] parameter.
class CustomTextfield extends StatefulWidget {
  /// The hint text to display when the field is empty.
  final String? hint;

  /// The label to display above the text field.
  final String? label;

  /// The fixed pixel height of the text field.
  final double? pixelHeight;

  /// The fixed pixel width of the text field.
  final double? pixelWidth;

  /// If true, always display the suffix icon regardless of focus or text content.
  final bool alwaysShowSuffixIcon;

  /// The default text to prepopulate the text field.
  final String defaultText;

  /// Callback when the text field is tapped.
  final void Function()? ontap;

  /// Callback when a tap outside the text field is detected.
  final void Function()? onTapOutside;

  /// Callback when the text changes.
  final Function(String text)? onchanged;

  /// Callback when the text is submitted.
  final Function(String text)? onSubmitted;

  /// Callback when editing is complete.
  final void Function()? onEditingComplete;

  /// The keyboard type to use for input.
  final TextInputType? keyboardType;

  /// A widget to display as the suffix icon.
  final Widget? suffixIcon;

  /// A widget to display as the prefix icon.
  final Widget? prefixIcon;

  /// Whether the text field should have a dense layout.
  final bool? isDense;

  /// Whether the text field should obscure the text (e.g., for passwords).
  final bool obscureText;

  /// The text style for the label.
  final TextStyle? labelStyle;

  /// The text style for the hint.
  final TextStyle? hintStyle;

  /// The text style for the input text.
  final TextStyle? inputTextStyle;

  /// The border radius for the text field.
  final double borderRadius;

  /// The background color of the text field.
  final Color? backgroundColor;

  /// The border to use for the text field.
  final InputBorder? border;

  /// The border to use when the text field is disabled.
  final InputBorder? disabledBorder;

  /// The border to use when the text field is enabled.
  final InputBorder? enabledBorder;

  /// The border to use when the text field is focused.
  final InputBorder? focusedBorder;

  /// An external [TextEditingController]. If null, one is created automatically.
  final TextEditingController? controller;

  /// How the text should be aligned.
  final TextAlign textAlign;

  /// Padding for the input content.
  final EdgeInsets inputContentPadding;

  /// An external [FocusNode]. If null, one is created automatically.
  final FocusNode? focusNode;

  /// The maximum number of lines for the text field.
  final int? maxLines;

  /// Whether the text field is enabled.
  final bool? isEnabled;

  /// The color of the cursor.
  final Color cursorColor;

  /// The maximum length of input.
  final int? maxLength;

  /// The height of the cursor.
  final double? cursorHeight;

  /// The width of the cursor.
  final double? cursorWidth;

  /// Whether the cursor opacity should animate.
  final bool? cursorOpacityAnimates;

  /// Whether to always show the cursor.
  final bool? showCursor;

  /// The color of the text selection.
  final Color? selectionColor;

  /// The color of the selection handles.
  final Color? selectionHandleColor;

  /// Additional constraints for the text field.
  final BoxConstraints? constraints;

  /// Optional input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Callback to pass internal arguments (controller and focus node) for custom usage.
  final Function(TextEditingController controller, FocusNode focusNode)? internalArgs;

  /// Callback for disposing additional resources.
  final Function(TextEditingController controller, FocusNode focusNode)? dispose2;

  

  const CustomTextfield({
    super.key,
    this.hint,
    this.label,
    this.alwaysShowSuffixIcon = false,
    this.defaultText = "",
    this.ontap,
    this.onTapOutside,
    this.onchanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.pixelHeight,
    this.pixelWidth,
    this.obscureText = false,
    this.hintStyle,
    this.labelStyle,
    this.inputTextStyle,
    this.borderRadius = 8,
    this.backgroundColor,
    this.border,
    this.disabledBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.controller,
    this.textAlign = TextAlign.start,
    this.inputContentPadding = EdgeInsets.zero,
    this.focusNode,
    this.maxLines,
    this.isEnabled = true,
    this.cursorColor = Colors.white,
    this.maxLength,
    this.inputFormatters,
    this.internalArgs,
    this.dispose2,
    this.isDense,
    this.constraints,
    this.cursorHeight,
    this.cursorWidth,
    this.cursorOpacityAnimates,
    this.showCursor,
    this.selectionColor,
    this.selectionHandleColor,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late TextEditingController controller;
  late FocusNode focusNode;
  late ValueNotifier<bool> showSuffixIcon;

  @override
  void initState() {
    super.initState();

    // Use widget's controller or create a new one
    controller = widget.controller ?? TextEditingController(text: widget.defaultText);
    // Use widget's focusNode or create a new one
    focusNode = widget.focusNode ?? FocusNode();

    // Add listeners
    controller.addListener(refreshSuffixIconState);
    focusNode.addListener(refreshSuffixIconState);

    showSuffixIcon = ValueNotifier(widget.alwaysShowSuffixIcon);

    if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
    
    // Update the suffix icon state initially
    refreshSuffixIconState();
  }

  @override
  void dispose() {
    // Remove listeners
    controller.removeListener(refreshSuffixIconState);
    focusNode.removeListener(refreshSuffixIconState);
    if (widget.dispose2 != null) widget.dispose2!(controller, focusNode);

    // Dispose controller, focusNode and state variables
    controller.dispose();
    focusNode.dispose();
    showSuffixIcon.dispose();
    super.dispose();
  }

  /// Updates [showSuffixIcon] based on focus and text input.
  void refreshSuffixIconState() {
    bool newState;
    if (widget.alwaysShowSuffixIcon) {
      newState = true;
    } else {
      if (widget.suffixIcon != null && focusNode.hasFocus) {
        newState = controller.text.isEmpty;
      } else {
        newState = false;
      }
    }
    if(showSuffixIcon.value != newState) showSuffixIcon.value = newState;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: widget.cursorColor, selectionColor: widget.selectionColor, selectionHandleColor: widget.selectionHandleColor)),
      child: TextField(
        enabled: widget.isEnabled,
        minLines: 1,
        maxLines: widget.maxLines ?? 1,
        textAlign: widget.textAlign,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        controller: controller,
        maxLength: widget.maxLength,
        focusNode: focusNode,
        onEditingComplete: () {
          refreshSuffixIconState();
          if (widget.onEditingComplete != null) widget.onEditingComplete!();
          if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
        },
        onSubmitted: (value) {
          refreshSuffixIconState();
          if (widget.onSubmitted != null) widget.onSubmitted!(value);
          if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
        },
        onChanged: (text) {
          refreshSuffixIconState();
          if (widget.onchanged != null) widget.onchanged!(text);
          if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
        },
        onTap: () {
          refreshSuffixIconState();
          if (widget.ontap != null) widget.ontap!();
          if (widget.internalArgs != null) widget.internalArgs!(controller, focusNode);
        },
        onTapOutside: (e) {
          refreshSuffixIconState();
          if (widget.onTapOutside == null) focusNode.unfocus();
          if (widget.onTapOutside != null) widget.onTapOutside!();
          if (widget.internalArgs != null && focusNode.hasFocus) widget.internalArgs!(controller, focusNode);
        },
        style: widget.inputTextStyle ?? const CustomText("").effectiveStyle(context),
        cursorColor: widget.cursorColor,
        cursorHeight: widget.cursorHeight,
        cursorWidth: widget.cursorWidth ?? 2.0,
        cursorOpacityAnimates: widget.cursorOpacityAnimates,
        showCursor: widget.showCursor,
        cursorRadius: const Radius.circular(12),
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          counterText: "",
          isDense: widget.isDense,
          hintText: widget.hint,
          labelText: widget.label,
          labelStyle: widget.labelStyle ??
              TextStyle(
                color: Colors.blueGrey,
              ),
          hintStyle: widget.hintStyle ??
              TextStyle(
                color: Colors.blueGrey,
              ),
          contentPadding: widget.inputContentPadding,
          border: widget.border ?? const OutlineInputBorder(),
          focusedBorder: widget.focusedBorder,
          enabledBorder: widget.enabledBorder,
          disabledBorder: widget.disabledBorder,
          constraints: widget.constraints ?? BoxConstraints.tightForFinite(width: widget.pixelWidth ?? 100, height: widget.pixelHeight ?? 48),
          filled: widget.backgroundColor == null ? false : true,
          fillColor: widget.backgroundColor,
          prefixIcon: widget.prefixIcon,
          suffixIcon: showSuffixIcon.value ? widget.suffixIcon! : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 4,
            minHeight: 4,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 4,
            minHeight: 4,
          ),
        ),
      ),
    );
  }
}
