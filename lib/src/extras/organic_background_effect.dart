import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

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
