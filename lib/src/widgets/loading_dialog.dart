import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

const loadingMessages = [
  "Just a moment...",
  "Please wait...",
  "Hold on...",
  "Loading, please wait...",
  "Hang tight...",
  "Almost there...",
  "Still with us? Just fine-tuning things...",
  "One moment please...",
  "Just a sec...",
  "Processing your request...",
  "Please hold on...",
  "Working on it...",
  "Stay with us...",
  "We're getting there...",
  "Give us a second...",
  "Waiting for things to load...",
  "Getting everything ready...",
  "Loading, please be patient...",
  "Please stand by...",
  "Getting things in order...",
  "Thank you for your patience...",
  "Just a little bit longer...",
  "Preparing your content...",
  "Completing tasks...",
  "We're almost ready...",
  "Almost done...",
  "Patience, we're on it...",
  "Wait just a little longer...",
  "Getting things set up...",
  "Hang on, loading now..."
];

/// Enum representing the allowed shape types: only circles and 4‑point stars.
enum ShapeType { circle, fourPointStar }

/// Data class representing a moving shape with oscillating size.
class CircleData {
  Offset position;
  double baseRadius;
  double currentRadius;
  final Offset drift;
  final Color color;
  final ShapeType shape;
  final double phase; // For oscillation offset

  CircleData({
    required this.position,
    required this.baseRadius,
    required this.currentRadius,
    required this.drift,
    required this.color,
    required this.shape,
    required this.phase,
  });
}

/// A frosty animated background that always animates. It draws a blurred,
/// full-screen background with softly colored shapes (either circles or 4‑point stars).
/// Optionally, you can supply a list of colors via [circleColors] from which the shapes
/// will be chosen at random. For 4‑point stars, the base radius is capped at 48px.
class FrostyBackground extends StatefulWidget {
  final double blurSigma;
  final List<Color>? circleColors;
  const FrostyBackground({
    super.key,
    this.blurSigma = 4.0,
    this.circleColors,
  });

  @override
  State<FrostyBackground> createState() => _FrostyBackgroundState();
}

class _FrostyBackgroundState extends State<FrostyBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _blurController;
  late final CurvedAnimation _curvedBlurAnimation;
  final List<CircleData> _circles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Ensure the system status bar is transparent.
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      _initializeCircles(size);
    });

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..addListener(() {
            _updateCircles();
            setState(() {});
          })
          ..repeat();
    _blurController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward(from: 0);
    _curvedBlurAnimation = CurvedAnimation(
        parent: _blurController,
        curve: CustomCurves.defaultIosSpring,
        reverseCurve: CustomCurves.snappySpring);
  }

  void _initializeCircles(Size size) {
    _circles.clear();
    int count = 10 + _random.nextInt(6); // between 10 and 15 shapes.
    for (int i = 0; i < count; i++) {
      double baseRadius =
          (size.width * 0.05) + _random.nextDouble() * (size.width * 0.15);
      // Only allow circles or 4-point stars.
      double shapeRoll = _random.nextDouble();
      ShapeType shape;
      if (shapeRoll < 0.8) {
        shape = ShapeType.circle;
      } else {
        shape = ShapeType.fourPointStar;
      }
      // For 4-point stars, cap the base radius at 48 pixels.
      if (shape == ShapeType.fourPointStar && baseRadius > 48) {
        baseRadius = 48;
      }
      double currentRadius = baseRadius;
      Offset position = Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      );
      Offset drift = Offset(
        (_random.nextDouble() - 0.5) * 0.5,
        (_random.nextDouble() - 0.5) * 0.5,
      );
      Color color;
      if (widget.circleColors != null && widget.circleColors!.isNotEmpty) {
        color =
            widget.circleColors![_random.nextInt(widget.circleColors!.length)];
      } else {
        double hue = _random.nextDouble() * 360;
        double saturation = 0.3 + _random.nextDouble() * 0.4;
        double alpha = 0.1 + _random.nextDouble() * 0.1; // 10% to 20% opacity.
        HSLColor hslColor = HSLColor.fromAHSL(alpha, hue, saturation, 0.5);
        color = hslColor.toColor();
      }
      double phase = _random.nextDouble() * 2 * pi;
      _circles.add(CircleData(
        position: position,
        baseRadius: baseRadius,
        currentRadius: currentRadius,
        drift: drift,
        color: color,
        shape: shape,
        phase: phase,
      ));
    }
  }

  void _updateCircles() {
    final size = MediaQuery.of(context).size;
    for (var circle in _circles) {
      // Oscillate size using a sine wave.
      circle.currentRadius = circle.baseRadius *
          (0.8 + 0.4 * sin(2 * pi * _controller.value + circle.phase));
      circle.position += circle.drift;
      // Wrap horizontally.
      if (circle.position.dx < -circle.currentRadius) {
        circle.position = Offset(
            size.width + circle.currentRadius + _random.nextDouble() * 20,
            circle.position.dy + _random.nextDouble() * 20);
      } else if (circle.position.dx > size.width + circle.currentRadius) {
        circle.position = Offset(
            -circle.currentRadius - _random.nextDouble() * 20,
            circle.position.dy - _random.nextDouble() * 20);
      }
      // Wrap vertically.
      if (circle.position.dy < -circle.currentRadius) {
        circle.position = Offset(circle.position.dx + _random.nextDouble() * 20,
            size.height + circle.currentRadius + _random.nextDouble() * 20);
      } else if (circle.position.dy > size.height + circle.currentRadius) {
        circle.position = Offset(circle.position.dx - _random.nextDouble() * 20,
            -circle.currentRadius - _random.nextDouble() * 20);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    // Use a very light background color (15% opacity).
    final Color bgColor = brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.15);

    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _CirclePainter(circles: _circles),
        ),
        AnimatedContainer(duration: Durations.extralong1, color: bgColor),
        AnimatedBuilder(
            animation: _curvedBlurAnimation,
            builder: (context, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: widget.blurSigma * _curvedBlurAnimation.value,
                    sigmaY: widget.blurSigma * _curvedBlurAnimation.value),
                child: Container(color: Colors.transparent),
              );
            }),
      ],
    );
  }
}

/// Custom painter that draws shapes based on [CircleData].
class _CirclePainter extends CustomPainter {
  final List<CircleData> circles;
  _CirclePainter({required this.circles});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (var circle in circles) {
      paint.color = circle.color;
      switch (circle.shape) {
        case ShapeType.circle:
          canvas.drawCircle(circle.position, circle.currentRadius, paint);
          break;
        case ShapeType.fourPointStar:
          _drawStar(canvas, circle.position, circle.currentRadius, 4, paint);
          break;
      }
    }
  }

  void _drawStar(
      Canvas canvas, Offset center, double radius, int points, Paint paint) {
    final Path path = Path();
    final double angle = (2 * pi) / points;
    final double halfAngle = angle / 2;
    final double innerRadius = radius * 0.5;
    for (int i = 0; i < points; i++) {
      double outerAngle = i * angle;
      double innerAngle = outerAngle + halfAngle;
      Offset outerPoint = Offset(
        center.dx + radius * cos(outerAngle),
        center.dy + radius * sin(outerAngle),
      );
      Offset innerPoint = Offset(
        center.dx + innerRadius * cos(innerAngle),
        center.dy + innerRadius * sin(innerAngle),
      );
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
    canvas.drawShadow(path, Colors.black, 2.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) => true;
}

class OrganicBackgroundEffect extends StatefulWidget {
  final List<Color>? gradientColors;
  final List<Color>? particleColors;
  final int particleCount;
  final double particleOpacity;
  final double gradientOpacity;
  final Duration pulseDuration;
  final Duration rotationDuration;
  final Duration? pulseReverseDuration;
  final Duration? rotationReverseDuration;

  const OrganicBackgroundEffect({
    super.key,
    this.gradientColors,
    this.particleColors,
    this.particleCount = 1000,
    this.particleOpacity = 0.07,
    this.gradientOpacity = 0.07, 
    this.pulseDuration = const Duration(milliseconds: 3000), 
    this.rotationDuration = const Duration(milliseconds: 10000), 
    this.pulseReverseDuration, 
    this.rotationReverseDuration,
    
  });

  @override
  State<OrganicBackgroundEffect> createState() =>
      _OrganicBackgroundEffectState();
}

class _OrganicBackgroundEffectState extends State<OrganicBackgroundEffect>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rotationController;
  final List<Particle> _particles = [];
  final Random _random = Random();

  // Default colors if none provided
  final List<Color> _defaultColors = [
    const Color(0xFF4285F4), // Google Blue
    const Color(0xFF34A853), // Google Green
    const Color(0xFFFBBC05), // Google Yellow
    const Color(0xFFEA4335), // Google Red
    const Color(0xFF9C27B0), // Purple
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
      reverseDuration: widget.pulseReverseDuration
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
      reverseDuration: widget.rotationReverseDuration
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeParticles();
    });
  }

  void _initializeParticles() {
    final size = MediaQuery.of(context).size;
    final particleColors = widget.particleColors ?? _defaultColors;

    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(Particle(
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        color: particleColors[_random.nextInt(particleColors.length)]
            .withValues(alpha: widget.particleOpacity),
        size: 1 + _random.nextDouble() * 2,
        speed: 0.2 + _random.nextDouble() * 0.3,
        angle: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Gradient background layer
            AnimatedBuilder(
              animation:
                  Listenable.merge([_pulseController, _rotationController]),
              builder: (context, child) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: GradientPainter(
                    colors: widget.gradientColors ?? _defaultColors,
                    pulseValue: _pulseController.value,
                    rotationValue: _rotationController.value,
                    opacity: widget.gradientOpacity,
                  ),
                );
              },
            ),
            // Particle layer
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: ParticlePainter(
                    particles: _particles,
                    animationValue: _rotationController.value,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class Particle {
  Offset position;
  final Color color;
  final double size;
  final double speed;
  final double angle;

  Particle({
    required this.position,
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class GradientPainter extends CustomPainter {
  final List<Color> colors;
  final double pulseValue;
  final double rotationValue;
  final double opacity;

  GradientPainter({
    required this.colors,
    required this.pulseValue,
    required this.rotationValue,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Create multiple gradient layers with different rotations
    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(size.width * 0.5, 0),
          Offset(size.width * 0.5, size.height),
          [
            colors[i].withValues(alpha: opacity),
            colors[(i + 1) % colors.length].withValues(alpha: opacity),
          ],
          [0, 1],
          TileMode.clamp,
          Matrix4.rotationZ(rotationValue * pi * 2 + (i * pi / colors.length))
              .storage,
        );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) => true;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Move particles in a more organic way
      final dx = cos(particle.angle + animationValue * particle.speed) * 2;
      final dy = sin(particle.angle + animationValue * particle.speed) * 2;

      particle.position = Offset(
        (particle.position.dx + dx) % size.width,
        (particle.position.dy + dy) % size.height,
      );

      final paint = Paint()
        ..color = particle.color
        ..strokeWidth = particle.size
        ..strokeCap = StrokeCap.round;

      canvas.drawPoints(
        ui.PointMode.points,
        [particle.position],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

/// A full-screen, animated loading page that always animates.
/// This page uses a transparent Scaffold with an animated frosty background
/// and a centered animated loading message.
class FrostyLoadingScaffold extends StatefulWidget {
  final String? msg;
  final Duration transitionDuration;
  final List<Color>? gradientColors;
  final List<Color>? particleColors;
  final List<Color>? circleColors;
  final bool canPop;
  final int particleCount;
  final double particleOpacity;
  final double gradientOpacity;
  final double blurSigma;
  final Color? msgTextColor;
  final double? msgTextSize;
  final TextStyle? msgTextStyle;
  final Widget? loadingInfoWidget;
  final Color? scaffoldBgColor;

  const FrostyLoadingScaffold({
    super.key,
    this.msg,
    this.transitionDuration = const Duration(milliseconds: 600),
    this.gradientColors,
    this.particleColors,
    this.canPop = true,
    this.circleColors,
    this.particleCount = 1000,
    this.particleOpacity = 0.07,
    this.gradientOpacity = 0.07,
    this.blurSigma = 4.0,
    this.msgTextColor,
    this.msgTextSize,
    this.msgTextStyle,
    this.loadingInfoWidget,
    this.scaffoldBgColor,
  });

  @override
  State<FrostyLoadingScaffold> createState() => _FrostyLoadingScaffoldState();
}

class _FrostyLoadingScaffoldState extends State<FrostyLoadingScaffold> {
  int msgIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      setState(() {
        msgIndex = (msgIndex + 1) % loadingMessages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AnimatedContainer(
            duration: widget.transitionDuration,
            color: widget.scaffoldBgColor ?? Colors.transparent,
            child: Stack(
              children: [
                // Organic background effect
                OrganicBackgroundEffect(
                  gradientColors: widget.gradientColors,
                  particleColors: widget.particleColors,
                  particleCount: widget.particleCount,
                  particleOpacity: widget.particleOpacity,
                  gradientOpacity: widget.gradientOpacity,
                ),
                // Frosty background
                FrostyBackground(
                  blurSigma: widget.blurSigma,
                  circleColors: widget.circleColors,
                ),
                // Loading message
                widget.loadingInfoWidget ??
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AnimatedSwitcher(
                          duration: widget.transitionDuration,
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(0, 0.5),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: CustomCurves.decelerate,
                            ));
                            if (widget.msg == null ||
                                (widget.msg != null && widget.msg!.isEmpty)) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                ),
                              );
                            }
                            return child;
                          },
                          child: CustomText(
                            widget.msg ?? loadingMessages[msgIndex],
                            key: ValueKey<int>(msgIndex),
                            color: widget.msgTextColor,
                            fontSize: widget.msgTextSize ?? 18,
                            style: widget.msgTextStyle,
                            shadows: const [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                  blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NormalLoadingScaffold extends StatefulWidget {
  final bool canPop;
  final String? msg;
  final Color? progressIndicatorColor;
  final Color? backgroundColor;
  final bool adaptToScreenSize;
  final Color? msgTextColor;
  final double? msgTextSize;
  final TextStyle? msgTextStyle;
  final Widget? loadingInfoWidget;
  final Color? scaffoldBgColor;
  final double blurSigma;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  /// Use CustomCurves
  final Curve? curve;

  const NormalLoadingScaffold(
      {super.key,
      this.canPop = false,
      this.msg,
      this.progressIndicatorColor,
      this.backgroundColor,
      this.adaptToScreenSize = false,
      this.msgTextColor,
      this.msgTextSize,
      this.blurSigma = 4.0,
      this.msgTextStyle,
      this.loadingInfoWidget,
      this.scaffoldBgColor,
      this.curve,
      this.transitionDuration = Durations.medium4,
      this.reverseTransitionDuration = Durations.medium1
      });

  @override
  State<NormalLoadingScaffold> createState() => _NormalLoadingScaffoldState();
}

class _NormalLoadingScaffoldState extends State<NormalLoadingScaffold>
    with SingleTickerProviderStateMixin {
  int msgIndex = 0;
  late Timer _timer;
  late final AnimationController _blurController;
  late final CurvedAnimation _curvedBlurAnimation;
  late final ColorTween _scaffoldBgColorTween;

  @override
  void initState() {
    super.initState();
    _blurController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
      reverseDuration: widget.reverseTransitionDuration,
    )..forward(from: 0);
    _curvedBlurAnimation = CurvedAnimation(
        parent: _blurController,
        curve: widget.curve ?? CustomCurves.decelerate,
        reverseCurve: widget.curve);
    _scaffoldBgColorTween = ColorTween(
        begin: Colors.blueGrey.withAlpha(10),
        end: widget.scaffoldBgColor ?? Colors.blueGrey.withAlpha(10));

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _blurController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      setState(() {
        msgIndex == loadingMessages.length - 1 ? msgIndex = 0 : msgIndex++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final ThemeData themeData = Theme.of(context);
    final isDarkMode = themeData.brightness == Brightness.dark;
    final primaryColor = themeData.primaryColor;

    return PopScope(
      canPop: widget.canPop,
      child: TweenAnimationBuilder(
        tween: _scaffoldBgColorTween,
        duration: widget.transitionDuration,
        curve: widget.curve ?? CustomCurves.decelerate,
        builder: (context, color, child) {
          return Scaffold(
            backgroundColor: color,
            body: AnimatedBuilder(
                animation: _curvedBlurAnimation,
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: widget.blurSigma * _curvedBlurAnimation.value,
                        sigmaY: widget.blurSigma * _curvedBlurAnimation.value),
                    child: widget.loadingInfoWidget ??
                        Align(
                          alignment: Alignment.center,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: widget.backgroundColor ??
                                    (isDarkMode ? Colors.black : Colors.white),
                                borderRadius: BorderRadius.circular(36),
                                border: Border.fromBorderSide(BorderSide(
                                    color: Colors.blueGrey
                                        .withValues(alpha: 0.05))),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset.zero,
                                      blurRadius: 4.0,
                                      spreadRadius: 2.0,
                                      color: Colors.blueGrey
                                          .withValues(alpha: 0.2),
                                      blurStyle: BlurStyle.outer)
                                ]),
                            child: SizedBox(
                              width: widget.adaptToScreenSize
                                  ? screenWidth * 0.6
                                  : 240,
                              height: widget.adaptToScreenSize
                                  ? screenWidth * 0.4
                                  : 160,
                              child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: CircularProgressIndicator(
                                        strokeCap: StrokeCap.round,
                                        color: widget.progressIndicatorColor ??
                                            primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 8, 12, 8),
                                      child: CustomText(
                                        widget.msg ?? loadingMessages[msgIndex],
                                        color: widget.msgTextColor ??
                                            Colors.blueGrey,
                                        fontSize: widget.msgTextSize ?? 14,
                                        style: widget.msgTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  );
                }),
          );
        },
      ),
    );
  }
}

class LoadingDialog {
  // Static reference to the current loading dialog route.
  static PageRoute? _currentLoadingRoute;

  /// Shows the loading dialog by pushing a custom route using [loadingDialogBuilder].
  /// It now takes the [BuildContext] as a required parameter.
  static Future<T?> showLoadingDialog<T>(BuildContext context,
      {bool isAnimatedDialog = false,
      String? msg,
      Color? msgTextColor,
      double? msgTextSize,
      TextStyle? msgTextStyle,
      bool? canPop,
      Color? backgroundColor,
      List<Color>? animatedColors,
      Color? progressIndicatorColor,
      Duration transitionDuration = Durations.medium4,
      Duration reverseTransitionDuration = Durations.medium1,
      /// Use CustomCurves to prevent unexpected behavior
      Curve? curve,

      /// For non-animatedDialog
      bool adaptToScreenSize = false,
      // Extra parameters for the animated scaffold:
      List<Color>? gradientColors,
      List<Color>? particleColors,
      int particleCount = 1000,
      double particleOpacity = 0.07,
      double gradientOpacity = 0.07,
      double blurSigma = 4.0,
      Color? scaffoldBgColor,
      Widget? loadingInfoWidget}) {
    final pageRoute = PageRouteBuilder(
      opaque: false,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        if (isAnimatedDialog) {
          return FrostyLoadingScaffold(
            msg: msg,
            canPop: canPop ?? true,
            transitionDuration: transitionDuration,
            scaffoldBgColor: scaffoldBgColor,
            loadingInfoWidget: loadingInfoWidget,
            circleColors: animatedColors,
            gradientColors: gradientColors,
            particleColors: particleColors,
            particleCount: particleCount,
            particleOpacity: particleOpacity,
            gradientOpacity: gradientOpacity,
            blurSigma: blurSigma,
            msgTextColor: msgTextColor,
            msgTextSize: msgTextSize,
            msgTextStyle: msgTextStyle,
          );
        } else {
          return NormalLoadingScaffold(
            msg: msg,
            canPop: canPop ?? false,
            progressIndicatorColor: progressIndicatorColor,
            backgroundColor: backgroundColor,
            scaffoldBgColor: scaffoldBgColor,
            blurSigma: blurSigma,
            loadingInfoWidget: loadingInfoWidget,
            adaptToScreenSize: adaptToScreenSize,
            msgTextColor: msgTextColor,
            msgTextSize: msgTextSize,
            msgTextStyle: msgTextStyle,
            transitionDuration: transitionDuration,
            reverseTransitionDuration: reverseTransitionDuration,
            curve: curve ?? CustomCurves.decelerate,
          );
        }
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Always apply a fade transition using the provided curve.
        final Animation<double> fadeAnimation =
            Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: curve ?? CustomCurves.decelerate));

        return FadeTransition(
          opacity: fadeAnimation,
          child: Builder(
            builder: (context) {
              
              return child;
            },
          ),
        );
      },
    );

    // Store the route reference.
    _currentLoadingRoute = pageRoute;

    // Push the route and clear the stored reference once it completes.
    return Navigator.of(context)
        .push<T>(pageRoute as Route<T>)
        .whenComplete(() {
      _currentLoadingRoute = null;
    });
  }

  /// Hides the loading dialog by popping the current route if it exists.
  /// If the dialog has already been popped or the context is no longer valid,
  /// this function will do nothing.
  static void hideLoadingDialog(BuildContext context) {
    if (_currentLoadingRoute != null) {
      // Check if the Navigator can pop before calling pop.
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _currentLoadingRoute = null;
    }
  }
}
