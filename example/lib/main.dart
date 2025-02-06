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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Curves & Physics Demo'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Curves Demo'),
              Tab(text: 'Scroll Physics Demo'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CurvesDemoPage(),
            ScrollPhysicsDemoPage(),
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

// Updated list of curve names with their corresponding Curve objects.
final List<MapEntry<String, Curve>> _curves = [
  // Flutter's built-in curves:
  const MapEntry('Linear', Curves.linear),
  const MapEntry('Ease', Curves.ease),
  const MapEntry('EaseIn', Curves.easeIn),
  const MapEntry('EaseOut', Curves.easeOut),
  const MapEntry('EaseInOut', Curves.easeInOut),
  const MapEntry('FastOutSlowIn', Curves.fastOutSlowIn),
  const MapEntry('Decelerate', Curves.decelerate),

  // Custom spring-based curves:
  MapEntry('Instant (Spring)', CustomCurves.instant),
  MapEntry('Default iOS (Spring)', CustomCurves.defaultIos),
  MapEntry('Bouncy (Spring)', CustomCurves.bouncy),
  MapEntry('Snappy (Spring)', CustomCurves.snappy),
  MapEntry('Interactive (Spring)', CustomCurves.interactive),
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
