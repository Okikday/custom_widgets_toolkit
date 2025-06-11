import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// A simple demo app to showcase custom curves and scroll physics.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curves & Scroll Physics Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

/// The HomePage provides two tabs: one for curves demo and one for scroll physics demo.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Curves & Physics Demo'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Curves Demo'),
              Tab(text: 'Scroll Physics Demo'),
              Tab(
                text: "Loading Dialog Demo",
              ),
              Tab(text: "Custom Snackbar Demo"),
              Tab(
                text: "Custom Widgets Demo",
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CurvesDemoPage(),
            ScrollPhysicsDemoPage(),
            LoadingDialogTestPage(),
            CustomSnackBarTestPage(),
            CustomWidgetsTestPage()
          ],
        ),
      ),
    );
  }
}

/// A demo page that animates a blue box horizontally using different curves.
class CurvesDemoPage extends StatefulWidget {
  const CurvesDemoPage({super.key});

  @override
  State<CurvesDemoPage> createState() => _CurvesDemoPageState();
}

class _CurvesDemoPageState extends State<CurvesDemoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<MapEntry<String, Curve>> _curves = [
    // Spring‑based curves:
    MapEntry('Instant (Spring)', CustomCurves.instantSpring),
    MapEntry('Default iOS (Spring)', CustomCurves.defaultIosSpring),
    MapEntry('Bouncy (Spring)', CustomCurves.bouncySpring),
    MapEntry('Snappy (Spring)', CustomCurves.snappySpring),
    MapEntry('Interactive (Spring)', CustomCurves.interactiveSpring),

    // Additional custom curves:
    MapEntry('Linear', CustomCurves.linear),
    MapEntry('Ease', CustomCurves.ease),
    MapEntry('Decelerate', CustomCurves.decelerate),
    MapEntry('FastSlowInOut', CustomCurves.fastSlowInOut),
    MapEntry('Bounce Out', CustomCurves.bounceOut),
    MapEntry('Bounce In', CustomCurves.bounceIn),

    // Additional smooth easing curves:
    MapEntry('Ease Out Sine', CustomCurves.easeOutSine),
    MapEntry('Ease In Out Sine', CustomCurves.easeInOutSine),
    MapEntry('Ease Out Circ', CustomCurves.easeOutCirc),
    MapEntry('Ease In Out Circ', CustomCurves.easeInOutCirc),
  ];

  int _selectedCurveIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _setupAnimation();
  }

  void _setupAnimation() {
    // Use the selected curve to build the animation.
    _animation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(
        parent: _controller,
        curve: _curves[_selectedCurveIndex].value,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<int>(
            value: _selectedCurveIndex,
            items: List.generate(
              _curves.length,
              (index) => DropdownMenuItem<int>(
                value: index,
                child: Text(_curves[index].key),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCurveIndex = value;
                  _setupAnimation();
                });
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startAnimation,
            child: const Text('Start Animation'),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            color: Colors.grey[300],
            child: Stack(
              children: [
                Positioned(
                  left: _animation.value,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 50,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Current Curve: ${_curves[_selectedCurveIndex].key}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

/// A demo page that shows a scrolling list using various custom scroll physics.
class ScrollPhysicsDemoPage extends StatefulWidget {
  const ScrollPhysicsDemoPage({super.key});

  @override
  State<ScrollPhysicsDemoPage> createState() => _ScrollPhysicsDemoPageState();
}

class _ScrollPhysicsDemoPageState extends State<ScrollPhysicsDemoPage> {
  // List of physics options with a label and corresponding ScrollPhysics.
  final List<MapEntry<String, ScrollPhysics>> _physicsList = [
    MapEntry('Android (Clamping)', CustomScrollPhysics.android()),
    MapEntry('iOS (Bouncing)', CustomScrollPhysics.ios()),
    MapEntry('SpringyGlow', CustomScrollPhysics.springyGlow()),
    MapEntry('Snappy', CustomScrollPhysics.snappy()),
    MapEntry('SmoothSpring', CustomScrollPhysics.smoothSpring()),
  ];
  int _selectedPhysicsIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<int>(
          value: _selectedPhysicsIndex,
          items: List.generate(
            _physicsList.length,
            (index) => DropdownMenuItem<int>(
              value: index,
              child: Text(_physicsList[index].key),
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedPhysicsIndex = value;
              });
            }
          },
        ),
        Expanded(
          child: ListView.builder(
            physics: _physicsList[_selectedPhysicsIndex].value,
            itemCount: 30,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A test page that shows two buttons: one to show the LoadingDialog,
/// and another to hide it.
class LoadingDialogTestPage extends StatefulWidget {
  const LoadingDialogTestPage({super.key});

  @override
  State<LoadingDialogTestPage> createState() => _LoadingDialogTestPageState();
}

class _LoadingDialogTestPageState extends State<LoadingDialogTestPage> {
  /// Shows the loading dialog using the LoadingDialog helper.
  void _showDialog(BuildContext context) {
    CustomDialog.instance.showLoadingDialog(
      context,
      msg: 'Please wait...',
      canPop: true,
    );
  }

  /// Hides the loading dialog if it is still active.
  void _hideDialog(BuildContext context) {
    CustomDialog.instance.hideDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Dialog Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showDialog(context),
              child: const Text('Show Loading Dialog'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _hideDialog(context),
              child: const Text('Hide Loading Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A test page to display CustomSnackBar examples for each SnackBarVibe.
class CustomSnackBarTestPage extends StatelessWidget {
  const CustomSnackBarTestPage({super.key});

  /// Helper function to show a SnackBar with the given vibe.
  void _showSnackBar(BuildContext context, SnackBarVibe vibe) {
    // Extract the vibe name (error, neutral, etc.) for display.
    final String vibeName = vibe.toString().split('.').last;
    CustomSnackBar.showSnackBar(
      context,
      content: 'This is a $vibeName SnackBar',
      vibe: vibe,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom SnackBar Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton(
              onPressed: () => _showSnackBar(context, SnackBarVibe.error),
              child: const Text('Error SnackBar'),
            ),
            ElevatedButton(
              onPressed: () => _showSnackBar(context, SnackBarVibe.success),
              child: const Text('Success SnackBar'),
            ),
            ElevatedButton(
              onPressed: () => _showSnackBar(context, SnackBarVibe.warning),
              child: const Text('Warning SnackBar'),
            ),
            ElevatedButton(
              onPressed: () => _showSnackBar(context, SnackBarVibe.none),
              child: const Text('None SnackBar'),
            ),
            ElevatedButton(
              onPressed: () => _showSnackBar(context, SnackBarVibe.info),
              child: const Text('Info SnackBar'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWidgetsTestPage extends StatefulWidget {
  const CustomWidgetsTestPage({super.key});

  @override
  State<CustomWidgetsTestPage> createState() => _CustomWidgetsTestPageState();
}

class _CustomWidgetsTestPageState extends State<CustomWidgetsTestPage> {
  // State variables for CustomElevatedButton
  bool _isButtonEnabled = true;
  double _buttonBorderRadius = 8.0;
  double _buttonElevation = 4.0;
  Color _buttonBackgroundColor = Colors.blueGrey;
  Color _buttonTextColor = Colors.white;
  double _buttonTextSize = 14.0;

  // State variables for CustomText
  String _customText = "Hello, World!";
  double _textFontSize = 14.0;
  Color _textColor = Colors.black;
  bool _isTextBold = false;
  bool _isTextItalic = false;
  TextDecoration _textDecoration = TextDecoration.none;

  // State variables for CustomTextfield
  String _textFieldHint = "Enter text";
  String _textFieldLabel = "Label";
  bool _isTextFieldEnabled = true;
  bool _isTextFieldObscure = false;
  double _textFieldBorderRadius = 8.0;
  Color _textFieldBackgroundColor = Colors.white;
  Color _textFieldTextColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Widgets Test Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomElevatedButton Section
            const Text(
              'CustomElevatedButton',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              label: _isButtonEnabled ? "Enabled Button" : "Disabled Button",
              onClick: _isButtonEnabled ? () => print("Button Clicked") : null,
              backgroundColor: _buttonBackgroundColor,
              borderRadius: _buttonBorderRadius,
              elevation: _buttonElevation,
              textColor: _buttonTextColor,
              textSize: _buttonTextSize,
            ),
            const SizedBox(height: 20),
            _buildButtonControls(),

            const Divider(height: 40),
            // CustomText Section
            const Text(
              'CustomText',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CustomText(
              _customText,
              fontSize: _textFontSize,
              color: _textColor,
              fontWeight: _isTextBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: _isTextItalic ? FontStyle.italic : FontStyle.normal,
              textDecoration: _textDecoration,
            ),
            const SizedBox(height: 20),
            _buildTextControls(),

            const Divider(height: 40),
            // CustomTextfield Section
            const Text(
              'CustomTextfield',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CustomTextfield(
              hint: _textFieldHint,
              label: _textFieldLabel,
              isEnabled: _isTextFieldEnabled,
              obscureText: _isTextFieldObscure,
              borderRadius: _textFieldBorderRadius,
              backgroundColor: _textFieldBackgroundColor,
              inputTextStyle: TextStyle(color: _textFieldTextColor),
            ),
            const SizedBox(height: 20),
            _buildTextFieldControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Enabled:"),
            Switch(
              value: _isButtonEnabled,
              onChanged: (value) => setState(() => _isButtonEnabled = value),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Border Radius:"),
            Slider(
              value: _buttonBorderRadius,
              min: 0,
              max: 50,
              onChanged: (value) => setState(() => _buttonBorderRadius = value),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Elevation:"),
            Slider(
              value: _buttonElevation,
              min: 0,
              max: 10,
              onChanged: (value) => setState(() => _buttonElevation = value),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Background Color:"),
            DropdownButton<Color>(
              value: _buttonBackgroundColor,
              items: [
                Colors.blueGrey,
                Colors.blue,
                Colors.red,
                Colors.green,
              ]
                  .map((color) => DropdownMenuItem(
                        value: color,
                        child: Container(
                          width: 20,
                          height: 20,
                          color: color,
                        ),
                      ))
                  .toList(),
              onChanged: (color) =>
                  setState(() => _buttonBackgroundColor = color!),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Text Color:"),
            DropdownButton<Color>(
              value: _buttonTextColor,
              items: [
                Colors.white,
                Colors.black,
                Colors.red,
                Colors.green,
              ]
                  .map((color) => DropdownMenuItem(
                        value: color,
                        child: Container(
                          width: 20,
                          height: 20,
                          color: color,
                        ),
                      ))
                  .toList(),
              onChanged: (color) => setState(() => _buttonTextColor = color!),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Text Size:"),
            Slider(
              value: _buttonTextSize,
              min: 8,
              max: 24,
              onChanged: (value) => setState(() => _buttonTextSize = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: "Text Content"),
          onChanged: (value) => setState(() => _customText = value),
        ),
        Row(
          children: [
            const Text("Font Size:"),
            Slider(
              value: _textFontSize,
              min: 8,
              max: 24,
              onChanged: (value) => setState(() => _textFontSize = value),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Text Color:"),
            DropdownButton<Color>(
              value: _textColor,
              items: [
                Colors.black,
                Colors.blue,
                Colors.red,
                Colors.green,
              ]
                  .map((color) => DropdownMenuItem(
                        value: color,
                        child: Container(
                          width: 20,
                          height: 20,
                          color: color,
                        ),
                      ))
                  .toList(),
              onChanged: (color) => setState(() => _textColor = color!),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Bold:"),
            Switch(
              value: _isTextBold,
              onChanged: (value) => setState(() => _isTextBold = value),
            ),
            const Text("Italic:"),
            Switch(
              value: _isTextItalic,
              onChanged: (value) => setState(() => _isTextItalic = value),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Decoration:"),
            DropdownButton<TextDecoration>(
              value: _textDecoration,
              items: [
                TextDecoration.none,
                TextDecoration.underline,
                TextDecoration.lineThrough,
                TextDecoration.overline,
              ]
                  .map((decoration) => DropdownMenuItem(
                        value: decoration,
                        child: Text(decoration.toString().split('.').last),
                      ))
                  .toList(),
              onChanged: (decoration) =>
                  setState(() => _textDecoration = decoration!),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: "Hint Text"),
          onChanged: (value) => setState(() => _textFieldHint = value),
        ),
        TextField(
          decoration: const InputDecoration(labelText: "Label Text"),
          onChanged: (value) => setState(() => _textFieldLabel = value),
        ),
        Row(
          children: [
            const Text("Enabled:"),
            Switch(
              value: _isTextFieldEnabled,
              onChanged: (value) => setState(() => _isTextFieldEnabled = value),
            ),
            const Text("Obscure Text:"),
            Switch(
              value: _isTextFieldObscure,
              onChanged: (value) => setState(() => _isTextFieldObscure = value),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Border Radius:"),
            Slider(
              value: _textFieldBorderRadius,
              min: 0,
              max: 50,
              onChanged: (value) =>
                  setState(() => _textFieldBorderRadius = value),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Background Color:"),
            DropdownButton<Color>(
              value: _textFieldBackgroundColor,
              items: [
                Colors.white,
                Colors.blueGrey,
                Colors.blue,
                Colors.red,
              ]
                  .map((color) => DropdownMenuItem(
                        value: color,
                        child: Container(
                          width: 20,
                          height: 20,
                          color: color,
                        ),
                      ))
                  .toList(),
              onChanged: (color) =>
                  setState(() => _textFieldBackgroundColor = color!),
            ),
          ],
        ),
        Row(
          children: [
            const Text("Text Color:"),
            DropdownButton<Color>(
              value: _textFieldTextColor,
              items: [
                Colors.black,
                Colors.blue,
                Colors.red,
                Colors.green,
              ]
                  .map((color) => DropdownMenuItem(
                        value: color,
                        child: Container(
                          width: 20,
                          height: 20,
                          color: color,
                        ),
                      ))
                  .toList(),
              onChanged: (color) =>
                  setState(() => _textFieldTextColor = color!),
            ),
          ],
        ),
      ],
    );
  }
}
