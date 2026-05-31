import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _ringController;
  late AnimationController _particleController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoTranslateY;
  late Animation<double> _iconScale;
  late Animation<double> _iconRotate;
  late Animation<double> _textTranslateY;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;
  late Animation<double> _progressWidth;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startTimeline();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _ringController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );
    _logoTranslateY = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOut,
      ),
    );

    _iconScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );
    _iconRotate = Tween<double>(begin: -0.35, end: 0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _textTranslateY = Tween<double>(begin: 16, end: 0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.elasticOut,
      ),
    );

    _ringScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: Curves.easeInOut,
      ),
    );
    _ringOpacity = Tween<double>(begin: 0.25, end: 0.55).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: Curves.easeInOut,
      ),
    );

    _progressWidth = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _startTimeline() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _logoController.forward();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      _progressController.forward();
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        context.go('/homepage');
        
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _ringController.dispose();
    _particleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE8D4A0),
        ),
        child: Stack(
          children: [
            _buildBackgroundCircles(),
            _buildParticles(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        _FloatingCircle(
          size: 340,
          top: -90,
          right: -70,
          color: const Color.fromRGBO(230, 200, 130, 0.22),
          duration: const Duration(seconds: 60),
        ),
        _FloatingCircle(
          size: 220,
          bottom: 50,
          left: -60,
          color: const Color.fromRGBO(200, 170, 110, 0.14),
          duration: const Duration(seconds: 80),
          reverse: true,
        ),
        _FloatingCircle(
          size: 150,
          top: MediaQuery.of(context).size.height * 0.28,
          left: MediaQuery.of(context).size.width * 0.08,
          color: const Color.fromRGBO(240, 220, 150, 0.10),
          duration: const Duration(seconds: 70),
          delay: const Duration(seconds: 10),
        ),
      ],
    );
  }

  Widget _buildParticles() {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        _Particle(
          top: size.height * 0.18,
          left: size.width * 0.15,
          size: 6,
          color: const Color.fromRGBO(245, 230, 170, 0.5),
          delay: const Duration(milliseconds: 3000),
        ),
        _Particle(
          top: size.height * 0.25,
          right: size.width * 0.20,
          size: 8,
          color: const Color.fromRGBO(235, 215, 150, 0.4),
          delay: const Duration(milliseconds: 8000),
        ),
        _Particle(
          bottom: size.height * 0.30,
          left: size.width * 0.25,
          size: 5,
          color: const Color.fromRGBO(240, 225, 160, 0.45),
          delay: const Duration(milliseconds: 12000),
        ),
        _Particle(
          bottom: size.height * 0.22,
          right: size.width * 0.15,
          size: 7,
          color: const Color.fromRGBO(225, 200, 135, 0.35),
          delay: const Duration(milliseconds: 5000),
        ),
        _Particle(
          top: size.height * 0.40,
          left: size.width * 0.08,
          size: 4,
          color: const Color.fromRGBO(250, 235, 180, 0.4),
          delay: const Duration(milliseconds: 15000),
        ),
        _Particle(
          top: size.height * 0.60,
          right: size.width * 0.10,
          size: 6,
          color: const Color.fromRGBO(230, 205, 145, 0.3),
          delay: const Duration(milliseconds: 20000),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 28),
                _buildAppName(),
              ],
            ),
          ),
        ),
        _buildSlogan(),
        const SizedBox(height: 40),
        _buildProgressBar(),
        const SizedBox(height: 40),
      ],
    );
  }

 

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _ringController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _logoTranslateY.value),
          child: Transform.scale(
            scale: _logoScale.value,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3426),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(60, 50, 35, 0.25),
                        blurRadius: 44,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -25,
                        right: -25,
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(60, 50, 40, 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Center(
                        child: Transform.scale(
                          scale: _iconScale.value,
                          child: Transform.rotate(
                            angle: _iconRotate.value,
                            child: _buildLogoIcon(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -7,
                  left: -7,
                  right: -7,
                  bottom: -7,
                  child: Transform.scale(
                    scale: _ringScale.value,
                    child: Opacity(
                      opacity: _ringOpacity.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromRGBO(150, 130, 110, 0.18),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoIcon() {
    return SizedBox(
      width: 54,
      height: 54,
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }

  Widget _buildAppName() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _textTranslateY.value),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '温时记',
                style: TextStyle(
                  fontFamily: 'KaiTi',
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3D3426),
                  letterSpacing: 6,
                ),
              ),
              _BlinkingDot(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlogan() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _textTranslateY.value),
          child: Opacity(
            opacity: _textController.value,
            child: Column(
              children: [
                
                const SizedBox(height: 10),
                Text(
                  '记录每一个重要时刻',
                  style: TextStyle(
                    fontFamily: 'KaiTi',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B5D4B),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 3,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(180, 160, 120, 0.18),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: _progressWidth.value,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(130, 105, 85, 0.45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
    }
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A853)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    paint.strokeWidth = 2.5;
    paint.color = const Color(0xFFD4A853).withOpacity(0.85);
    canvas.drawCircle(center, 16, paint);

    paint.strokeWidth = 2.8;
    paint.color = const Color(0xFFD4A853).withOpacity(0.7);
    canvas.drawLine(Offset(center.dx, 6), Offset(center.dx, 11), paint);

    paint.color = const Color(0xFFD4A853).withOpacity(0.55);
    canvas.drawLine(
      Offset(center.dx + 16.5, 15),
      Offset(center.dx + 12.8, 18.2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - 16.5, 15),
      Offset(center.dx - 12.8, 18.2),
      paint,
    );

    paint.strokeWidth = 2.5;
    paint.color = const Color(0xFFD4A853);
    canvas.drawLine(center, Offset(center.dx, 18), paint);

    paint.strokeWidth = 2;
    canvas.drawLine(center, Offset(center.dx + 8, 24), paint);

    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, 2.5, paint);

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = const Color(0xFFD4A853).withOpacity(0.2);
    final dashPaint = Paint()
      ..color = const Color(0xFFD4A853).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    _drawDashedCircle(canvas, center, 22, dashPaint, 4, 6);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius,
      Paint paint, double dash, double gap) {
    final circumference = 2 * radius * 3.14159;
    final total = dash + gap;
    final dashes = (circumference / total).floor();
    final step = total / radius;

    for (int i = 0; i < dashes; i++) {
      final start = i * step;
      final end = start + dash / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        end - start,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FloatingCircle extends StatefulWidget {
  final double size;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final Color color;
  final Duration duration;
  final bool reverse;
  final Duration delay;

  const _FloatingCircle({
    required this.size,
    this.top,
    this.right,
    this.bottom,
    this.left,
    required this.color,
    required this.duration,
    this.reverse = false,
    this.delay = Duration.zero,
  });

  @override
  State<_FloatingCircle> createState() => _FloatingCircleState();
}

class _FloatingCircleState extends State<_FloatingCircle>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _offset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(12, -18),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: widget.top,
          right: widget.right,
          bottom: widget.bottom,
          left: widget.left,
          child: Transform.translate(
            offset: widget.reverse ? -_offset.value : _offset.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Particle extends StatefulWidget {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double size;
  final Color color;
  final Duration delay;

  const _Particle({
    this.top,
    this.right,
    this.bottom,
    this.left,
    required this.size,
    required this.color,
    required this.delay,
  });

  @override
  State<_Particle> createState() => _ParticleState();
}

class _ParticleState extends State<_Particle> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _translateY;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    );

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.0), weight: 20),
    ]).animate(_controller);

    _translateY = Tween<double>(begin: 20, end: -40).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 80),
    ]).animate(_controller);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: widget.top,
          right: widget.right,
          bottom: widget.bottom,
          left: widget.left,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.translate(
              offset: Offset(0, _translateY.value),
              child: Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 15000),
      vsync: this,
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 12000), () {
      if (mounted) {
        _controller.forward();
      }
    });

    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Transform.scale(
            scale: _scale.value,
            child: Opacity(
              opacity: _opacity.value,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B6F3A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
    