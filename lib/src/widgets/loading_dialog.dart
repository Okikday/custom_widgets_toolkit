import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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
    this.pulseDuration = const Duration(milliseconds: 5000),
    this.rotationDuration = const Duration(milliseconds: 5000),
    this.pulseReverseDuration,
    this.rotationReverseDuration,
  });

  @override
  State<OrganicBackgroundEffect> createState() => _OrganicBackgroundEffectState();
}

class _OrganicBackgroundEffectState extends State<OrganicBackgroundEffect> with TickerProviderStateMixin {
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

    _pulseController = AnimationController(vsync: this, duration: widget.pulseDuration, reverseDuration: widget.pulseReverseDuration)
      ..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
      reverseDuration: widget.rotationReverseDuration,
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
      _particles.add(
        Particle(
          position: Offset(_random.nextDouble() * size.width, _random.nextDouble() * size.height),
          color: particleColors[_random.nextInt(particleColors.length)].withValues(alpha: widget.particleOpacity),
          size: 1 + _random.nextDouble() * 2,
          speed: 0.2 + _random.nextDouble() * 0.3,
          angle: _random.nextDouble() * 2 * pi,
        ),
      );
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
          clipBehavior: Clip.hardEdge,
          children: [
            // Gradient background layer
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_pulseController, _rotationController]),
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
              ),
            ),
            // Particle layer
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: ParticlePainter(particles: _particles, animationValue: _rotationController.value),
                    );
                  },
                ),
              ),
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

  Particle({required this.position, required this.color, required this.size, required this.speed, required this.angle});
}

class GradientPainter extends CustomPainter {
  final List<Color> colors;
  final double pulseValue;
  final double rotationValue;
  final double opacity;

  GradientPainter({required this.colors, required this.pulseValue, required this.rotationValue, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Create multiple gradient layers with different rotations
    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(size.width * 0.5, 0),
          Offset(size.width * 0.5, size.height),
          [colors[i].withValues(alpha: opacity), colors[(i + 1) % colors.length].withValues(alpha: opacity)],
          [0, 1],
          TileMode.clamp,
          Matrix4.rotationZ(rotationValue * pi * 2 + (i * pi / colors.length)).storage,
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

  ParticlePainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Move particles in a more organic way
      final dx = cos(particle.angle + animationValue * particle.speed) * 2;
      final dy = sin(particle.angle + animationValue * particle.speed) * 2;

      particle.position = Offset((particle.position.dx + dx) % size.width, (particle.position.dy + dy) % size.height);

      final paint = Paint()
        ..color = particle.color
        ..strokeWidth = particle.size
        ..strokeCap = StrokeCap.round;

      canvas.drawPoints(ui.PointMode.points, [particle.position], paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
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
  final Offset blurSigma;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  /// Use CustomCurves
  final Curve? curve;

  const NormalLoadingScaffold({
    super.key,
    this.canPop = false,
    this.msg,
    this.progressIndicatorColor,
    this.backgroundColor,
    this.adaptToScreenSize = false,
    this.msgTextColor,
    this.msgTextSize,
    this.blurSigma = const Offset(2.0, 2.0),
    this.msgTextStyle,
    this.loadingInfoWidget,
    this.scaffoldBgColor,
    this.curve,
    this.transitionDuration = Durations.medium4,
    this.reverseTransitionDuration = Durations.medium1,
  });

  @override
  State<NormalLoadingScaffold> createState() => _NormalLoadingScaffoldState();
}

class _NormalLoadingScaffoldState extends State<NormalLoadingScaffold> with SingleTickerProviderStateMixin {
  int msgIndex = 0;
  late final AnimationController _blurController;
  late final Animation<Offset> _curvedBlurAnimation;
  late final ColorTween _scaffoldBgColorTween;

  @override
  void initState() {
    super.initState();
    _blurController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
      reverseDuration: widget.reverseTransitionDuration,
    )..forward(from: 0);
    _curvedBlurAnimation = Tween<Offset>(begin: Offset.zero, end: widget.blurSigma).animate(CurvedAnimation(
      parent: _blurController,
      curve: widget.curve ?? CustomCurves.decelerate,
      reverseCurve: widget.curve,
    ));
    _scaffoldBgColorTween = ColorTween(begin: Colors.blueGrey.withAlpha(10), end: widget.scaffoldBgColor ?? Colors.blueGrey.withAlpha(10));
  }

  @override
  void dispose() {
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final ThemeData themeData = Theme.of(context);
    final isDarkMode = themeData.brightness == Brightness.dark;
    final primaryColor = themeData.primaryColor;

    return PopScope(
        canPop: widget.canPop,
        onPopInvokedWithResult: (didPop, result) {
          if (widget.canPop) _blurController.reverse();
        },
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _blurController,
            builder: (context, child) {
              final Color? color = _scaffoldBgColorTween.evaluate(_blurController);
              return Scaffold(
                backgroundColor: color,
                body: child,
              );
            },
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _curvedBlurAnimation,
                builder: (context, child) {
                  return RepaintBoundary(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _curvedBlurAnimation.value.dx,
                        sigmaY: _curvedBlurAnimation.value.dy,
                      ),
                      child: widget.loadingInfoWidget ??
                          Align(
                            alignment: Alignment.center,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: widget.backgroundColor ?? (isDarkMode ? Colors.black : Colors.white),
                                borderRadius: BorderRadius.circular(36),
                                border: Border.fromBorderSide(BorderSide(color: Colors.blueGrey.withValues(alpha: 0.05))),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset.zero,
                                    blurRadius: 4.0,
                                    spreadRadius: 2.0,
                                    color: Colors.blueGrey.withValues(alpha: 0.2),
                                    blurStyle: BlurStyle.outer,
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: widget.adaptToScreenSize ? screenWidth * 0.6 : 240,
                                height: widget.adaptToScreenSize ? screenWidth * 0.4 : 160,
                                child: ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: CircularProgressIndicator(
                                          strokeCap: StrokeCap.round,
                                          color: widget.progressIndicatorColor ?? primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        child: CustomText(
                                          widget.msg ?? "Just a moment...",
                                          color: widget.msgTextColor ?? Colors.blueGrey,
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
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}

class LoadingDialog {
  // Static reference to the current loading dialog route.
  static PageRoute? _currentLoadingRoute;

  /// Shows the loading dialog by pushing a custom route using [loadingDialogBuilder].
  /// It now takes the [BuildContext] as a required parameter.
  static Future<T?> showLoadingDialog<T>(
    BuildContext context, {
    String? msg,
    Color? msgTextColor,
    double? msgTextSize,
    TextStyle? msgTextStyle,
    bool? canPop,
    Color? backgroundColor,
    Color? progressIndicatorColor,
    Duration transitionDuration = Durations.medium4,
    Duration reverseTransitionDuration = Durations.medium2,

    /// Use CustomCurves to prevent unexpected behavior
    Curve? curve,

    /// For non-animatedDialog
    bool adaptToScreenSize = false,
    Offset blurSigma = Offset.zero,
    Color? barrierColor,
    Widget? loadingInfoWidget,
    TransitionType transitionType = TransitionType.fade,
  }) {
    final scaffold = NormalLoadingScaffold(
      msg: msg,
      canPop: canPop ?? false,
      progressIndicatorColor: progressIndicatorColor,
      backgroundColor: backgroundColor,
      scaffoldBgColor: barrierColor,
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

    final pageRoute = PageAnimation.pageRouteBuilder(
      scaffold,
      type: transitionType,
      duration: transitionDuration,
      reverseDuration: reverseTransitionDuration,
      opaque: false,
    );

    // Store the route reference.
    _currentLoadingRoute = pageRoute;

    // Push the route and clear the stored reference once it completes.
    return Navigator.of(context).push<T>(pageRoute as Route<T>).whenComplete(() {
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

  static const loadingMessages = [
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
    "Hang on, loading now...",
  ];
}
