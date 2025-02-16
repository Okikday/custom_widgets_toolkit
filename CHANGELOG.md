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
  Introduced a new helper class for displaying custom-styled SnackBars throughout the app.
  
- **SnackBarVibe Enum:**  
  Created an enumeration (`SnackBarVibe`) to represent different visual states: `error`, `neutral`, `success`, and `warning`.

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

