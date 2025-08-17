## 0.0.1

* [1.0.0] - Initial Release  
  **Added:**  
  - **Constant Sizing Utilities:** Easily manage widget dimensions with `constant_sizing.dart`.  
  - **Custom Scroll Physics:** Smooth scrolling experience with `custom_scroll_physics.dart`.  
  - **Spring Animation Curves:** Improved animations using `custom_spring_curves.dart`.  
  - **Custom Widgets:**  
    - `custom_elevated_button.dart`: Enhanced elevated button with extended customization options.  
    - `custom_rich_text.dart`: Rich text widget supporting advanced text formatting.  
    - `custom_text_button.dart`: Flexible text button with custom styling.  
    - `custom_text.dart`: Dark mode-aware and highly customizable text widget extending `Text`.  
    - `custom_textfield.dart`: Text field widget supporting advanced validation and styling.  
    - `loading_dialog.dart`: Lightweight and customizable loading dialog for UI feedback.

## 0.0.3

- **custom_rich_text.dart:** Updated and fixed functionality  
- **custom_text.dart**

## 0.0.31

- **custom_spring_curves.dart:** Reduced curves  
- **custom_textfield.dart:** Improved

## 0.0.32

**Custom Curves Enhancements:**  
- **Smooth Easing Curves Added:** Introduced additional smooth easing curves—`easeOutSine`, `easeInOutSine`, `easeOutCirc`, and `easeInOutCirc`—to complement the existing spring‑based curves.  
- **Unique Identifiers:** Updated the `_LambdaCurve` implementation to include unique IDs for each curve, ensuring accurate equality checks and proper selection in UI elements.  
- **Spring Curve Renaming:** Renamed spring‑based curves to clearly include “Spring” in their names (e.g. `instantSpring`, `defaultIosSpring`, etc.) for better clarity in the curve options.

**Custom Widget Improvements:**  
- **CustomTextButton Enhancements:** Extended the custom text button widget to support icon integration via `TextButton.icon` and increased customization over styling, size, and padding.  
- **General Refinements:** Made minor tweaks in `custom_text.dart` and `custom_textfield.dart` to improve performance and ensure UI consistency.

## 0.0.32
- **Fixed little onSubmitted bug in CustomTextfield**

## 0.0.33
- **Added documentation for CustomText**

## 0.0.34
- **Added comprehensive documentation comments to all classes, enums, and methods to explain their purpose and functionality.**
- **Finalized the full-screen loading page (FrostyLoadingScaffold) with all extra parameters (including gradient and particle options) for maximum customization.**

## 0.0.35
### Added
- **CustomSnackBar Helper Class:**  
- **Introduced a new helper class for displaying custom-styled SnackBars throughout the app.**
  
- **SnackBarVibe Enum:**  
- **Created an enumeration (`SnackBarVibe`) to represent different visual states: `error`, `neutral`, `success`, and `warning`.**

- **Theme-Aware Color Mapping:**  
  Added color maps for both light and dark modes.  
  - Light mode uses lighter shades (e.g., `Colors.red.shade50` for the background) and darker primary colors (e.g., `Colors.red`).
  - Dark mode uses darker background colors (e.g., `Colors.red.shade900`) and softer primary colors (e.g., `Colors.red.shade300`).

- **Customization Options:**  
  Allowed optional parameters to override:
  - `backgroundColor`
  - `textStyle`
  - `icon`
  - `contentWidget`
  - `dismissDirection`
  - `shape`
  - `duration`

- **User Experience Enhancements:**  
  - Automatically removes any currently visible SnackBar before showing a new one.
  - Applies a floating behavior with a custom margin and a rounded rectangular shape with a colored border.


## 0.0.36
- **Updates readme.md** 

## 0.0.37
- **Fixed SnackBarVibe enum to show**

## 0.0.38
- **Custom Scroll Physics Update:**  
  Replaced all references to the deprecated `tolerance` getter with `toleranceFor(position)` in the `CustomScrollPhysics` class, ensuring compatibility with the latest Flutter API standards.

- **Custom SnackBar Enhancements:**
  - Improved `SnackBarVibe` enum handling to ensure the correct vibe is displayed.
  - Minor refinements to `CustomSnackBar` for better theme consistency and error handling.  
  - Improved example page

## 0.0.39
- **Custom SnackBar Color Scheme Update: Important Update**
  - Updated `CustomSnackBar` to always use light background colors (using `Colors.shade50`) for a consistent and bright appearance.
  - Adjusted text, icon, and border colors to use darker shades (using `Colors.shade800`) to ensure excellent contrast and visibility.
  - Removed dark mode-specific color logic to maintain a uniform look across themes.

## 0.0.40
- **Stabilized packaged: NOTE: this version has breaking changes**
- **Refined colors in custom snackbar**
- **Deprecated loadingDialogBuilder, use showDialog instead e.g LoadingDialog.showDialog(context)...**
- **Added property to change textColor, textSize and textStyle ultimately in loadingDialog**
- **Refined loadingDialog colors and texture**
- **Fixed major bugs on loadingDialog**
- **Most stable version**

## 0.0.41
- **Added more properties to CustomTextfield**
- **Improved CustomElevatedButton, button's background color now automatically adapts to app's theme color**
- **Added more widget to example file**

## 0.0.42
- **Fixed the scaffold background issue with the loading dialog and renamed for better usage**
- **Added option for scaffold background color and an option to put a custom widget in the loading dialog**
- **Adjusted CustomElevatedButton's default padding to be more usable on default settings**

## 0.0.43
- **Fixed little animation controller disposal error**

## 0.0.44
- **Added spacing widgets(ConstantSizing.rowSpacing..., ConstantSizing.columnSpacing...) for Rows, Columns or any other widget you might want to use it for**
- **Adjusted CustomTextfield to use the the default set border or the border you set for it's focused state, or enabled state**

## 0.0.45
- **Updated Colors on snackbar and added more arguments**
- **Breaking change: removed SnackBarVibe.neutral**

## 0.0.46
- **Fixed blurSigma not getting applied for non-animated Dialog**
- **Note: You can use the LoadingDialog to display dialog for other things. Would deprecate for a CustomDialog in the future for utils such as Loading, Alert etc**

## 0.0.47
- **Little fix to non-animated background color in LoadingDialog**
-**Reminder: You can use the LoadingDialog to display dialog for other things. just use the loadingInfoWidget property**

## 0.0.48
- **Fix toolbar now showing up in CustomTextField**

## 0.0.49
- **You can now parse the "enabled" and "delay" arguments in CustomElevatedButton**

## 0.0.50
- **Adjusted for when custom elevated button's onClick argument isn't parsed**

## 0.0.51
- **Fixed where rowSpacing applies for height instead**

## 0.0.52
- **Fixed [CustomTextButton] where onClick and onLongClick doesn't work**

## 0.0.53
- **Adjusted the overlayColor for [CustomElevatedButton].**
- **Exposed the [OrganicEffectBackground]**
- **Adjusted LoadingDialog sync duration to match duration arguments parsed**

# 0.0.54
- **Added [PageAnimation] -> You can use it to animate your pages without external package or dependency. Can customize Transition with TransitionType enum**
- **Applied it to LoadingDialog for flexibility**

# 0.0.55
- **Fixed LoadingDialog backgroundColor not getting applied**

# 0.0.56
- **Added more PageAnimations**

## 0.0.57
- **Added arguments for minLines in CustomTextfield**

## 0.0.58
- **Removed limits to CustomTextfield width and height**

## 0.0.59
- **Adjust [CustomTextfield] allow counterText arguments, also allowing to use [CustomTextfield().getEffectiveInputDecoration()] to get the default inputDecoration which can be used alongside copyWith or another textfield**


## 0.0.60
- **Breaking changes, removed isAnimatedDialog under LoadingDialog. more simplified**

## 0.0.61
- **Breaking changes, blurSigma in [LoadingDialog] is now of type Offset instead of double**
- **Changed default TransitionType for [LoadingDialog] to [TransitionType.none]**
- **Removed ordinary levelFrom... TransitionType for the ones withFade**
- **Added scaleFrom... TransitionType(s)**

## 0.0.62
- **Changed default TransitionType for [LoadingDialog] to [TransitionType.fade] for minimalism**
- **Improved performance on LoadingDialog**


## 0.0.63
- **Improved performance for LoadingDialog**
- **Removed blur by default on LoadingDialog background**


## 0.0.64
- **Breaking Changes**
- **Removed the dispose2 in CustomTextfield. Added an autoDispose toggle whether to automatically clear assigned Controller/FocusNode(Clears by default)**
- **Replaced LoadingDialog with CustomDialog. Do not update if your project relies on LoadingDialog**


## 0.0.65
- **Adjusted the CustomDialog use instance in order to allow multiple dialogs, hiding dialogs and to prevent confusion**


## 0.0.66
- **Breaking code changes**
- **Fixed bug with CustomDialog where Dialog gets stuck. Can now hideLast or hideAll Dialogs**

## 0.0.67
- **Fixed bug where the hideAll doesn't close all**

## 0.0.68
- **Caught possible errors**

## 0.0.69
- **Due to errors popping up, CustomDialog will use just one instance to be safer**
- **Stable**


## 0.0.70
- **Improved CustomDialog performance to only use blur when only assigned**


## 0.0.71
- **Added more properties to CustomElevatedButton**

## 0.0.72
- **Added more properties for CustomDialog**

## 0.0.73
- **Allowed ButtonStyle on CustomTextButton**
- **Fixed CustomRichText onEnter, onExit and mourseCursor**