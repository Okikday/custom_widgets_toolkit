# Flutter Custom Widgets Package

This package provides a curated set of custom components and widgets that simplify Flutter UI development. It streamlines configuration by exposing tailored properties, helping you build beautiful interfaces quickly with less boilerplate.

## Table of Contents
- [Custom Components](#custom-components)
- [Custom Widgets](#custom-widgets)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Custom Components

**`lib/src/others/`**
- **constant_sizing.dart:** Predefined sizing constants for design consistency. e.g ConstantSizing.columnSpacingSmall, ConstantSizing.rowSpacing(12) => easy to use
- **custom_scroll_physics.dart:** Tailored scroll behavior.
- **custom_curves.dart:** Spring-like curves and other smooth curves for natural UI transitions.

## Custom Widgets

**`lib/src/widgets/`**
- **custom_elevated_button.dart:** Enhanced ElevatedButton with extra customization.
- **custom_rich_text.dart:** Rich text widget with flexible styling.
- **custom_text_button.dart:** Styled text button for intuitive interactions.
- **custom_text.dart:** Versatile text widget with dynamic styling.
- **custom_textfield.dart:** Advanced text input field with built-in validation.
- **loading_dialog.dart:** Customizable/animated loading dialog for smooth operation feedback.
- **custom_snackbar.dart:** Custom snackbar offering flexible usage.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  custom_widgets_toolkit: ^0.0.58
```