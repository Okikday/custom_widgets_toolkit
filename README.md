# Flutter Custom Widgets Package

This package contains a collection of custom components and widgets designed to simplify UI building and enhance the user experience in Flutter applications.

## Table of Contents
- [Custom Components](#custom-components)
- [Custom Widgets](#custom-widgets)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Custom Components

### `lib/src/others/`
- **constant_sizing.dart**: Contains predefined constant values for sizing elements to ensure consistency across the app.
- **custom_scroll_physics.dart**: Custom scroll behavior for a more tailored scrolling experience.
- **custom_spring_curves.dart**: Provides spring-like animations using custom curves for a more natural feel in UI transitions.

## Custom Widgets

### `lib/src/widgets/`
- **custom_elevated_button.dart**: A custom implementation of an ElevatedButton with additional properties for customization.
- **custom_text_button.dart**: A styled text button widget with support for custom actions and appearance.
- **custom_text.dart**: A versatile text widget that allows easy styling with dynamic properties.
- **custom_textfield.dart**: A custom text input field widget with enhanced styling and input validation.
- **loading_dialog.dart**: A loading dialog widget to show an animated loading indicator during data processing or app operations.

## Installation

To use this package in your Flutter project, follow these steps:

1. Add the package to your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     custom_widgets_toolkit: ^0.0.1
