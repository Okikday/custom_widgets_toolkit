import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class OrganicSearchEffect extends StatefulWidget {
  final double size;
  final List<Color>? colors;
  final int particleCount;

  const OrganicSearchEffect({
    super.key,
    this.size = 200,
    this.colors,
    this.particleCount = 200,
  });

  @override
  State<OrganicSearchEffect> createState() => _OrganicSearchEffectState();
}

class _OrganicSearchEffectState extends State<OrganicSearchEffect>
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

    // Initialize pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Initialize rotation animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();

    // Initialize particles
    _initializeParticles();
  }

  void _initializeParticles() {
    final colors = widget.colors ?? _defaultColors;
    for (int i = 0; i < widget.particleCount; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final radius = _random.nextDouble() * (widget.size / 2);
      _particles.add(Particle(
        position: Offset(
          radius * cos(angle),
          radius * sin(angle),
        ),
        color: colors[_random.nextInt(colors.length)]
            .withValues(alpha: 0.1 + _random.nextDouble() * 0.2),
        size: 1 + _random.nextDouble() * 2,
        speed: 0.2 + _random.nextDouble() * 0.3,
        angle: angle,
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Gradient background layer
          AnimatedBuilder(
            animation:
                Listenable.merge([_pulseController, _rotationController]),
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: GradientPainter(
                  colors: widget.colors ?? _defaultColors,
                  pulseValue: _pulseController.value,
                  rotationValue: _rotationController.value,
                ),
              );
            },
          ),
          // Particle layer
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: ParticlePainter(
                  particles: _particles,
                  animationValue: _rotationController.value,
                ),
              );
            },
          ),
        ],
      ),
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

  GradientPainter({
    required this.colors,
    required this.pulseValue,
    required this.rotationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * (0.8 + pulseValue * 0.2);

    // Create multiple gradient layers with different rotations
    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          center,
          radius,
          [
            colors[i].withValues(alpha: 0.3),
            colors[(i + 1) % colors.length].withValues(alpha: 0.3),
          ],
          [0, 1],
          TileMode.clamp,
          Matrix4.rotationZ(rotationValue * pi * 2 + (i * pi / colors.length))
              .storage,
        );

      canvas.drawCircle(center, radius, paint);
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
    final center = Offset(size.width / 2, size.height / 2);

    for (var particle in particles) {
      // Update particle position
      final angle = particle.angle + animationValue * 2 * pi * particle.speed;
      final radius = (particle.position - center).distance;
      final newPosition = center +
          Offset(
            radius * cos(angle),
            radius * sin(angle),
          );

      final paint = Paint()
        ..color = particle.color
        ..strokeWidth = particle.size
        ..strokeCap = StrokeCap.round;

      canvas.drawPoints(
        ui.PointMode.points,
        [newPosition],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
