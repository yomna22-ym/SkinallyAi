import 'dart:math';
import 'package:flutter/material.dart';

class Interactive3DCard extends StatefulWidget {
  final Widget child;
  final bool autoRotate;
  final bool enableOnMobile;

  const Interactive3DCard({
    super.key,
    required this.child,
    this.autoRotate = false,
    this.enableOnMobile = false,
  });

  @override
  State<Interactive3DCard> createState() => _Interactive3DCardState();
}

class _Interactive3DCardState extends State<Interactive3DCard>
    with TickerProviderStateMixin { // Changed from SingleTickerProviderStateMixin
  double _x = 0;
  double _y = 0;
  late AnimationController _controller;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    if (widget.autoRotate) {
      _controller.repeat(reverse: true);
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _x = sin(_controller.value * 2 * pi) * 0.05;
            _y = cos(_controller.value * 2 * pi) * 0.05;
          });
        }
      });
    }
  }

  bool get _isMobile {
    final data = MediaQuery.of(context);
    return data.size.width < 600;
  }

  void _updateRotation(Offset offset, Size size) {
    if (_isMobile && !widget.enableOnMobile) return;

    final dx = offset.dx;
    final dy = offset.dy;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    setState(() {
      // Reduced rotation intensity for better mobile experience
      final intensity = _isMobile ? 0.1 : 0.2;
      _x = (dy - centerY) / centerY * intensity;
      _y = -(dx - centerX) / centerX * intensity;
    });
  }

  void _resetRotation() {
    if (!widget.autoRotate) {
      setState(() {
        _x = 0;
        _y = 0;
      });
    }
  }

  void _onHoverStart() {
    _hoverController.forward();
  }

  void _onHoverEnd() {
    _hoverController.reverse();
    _resetRotation();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverStart(),
      onExit: (_) => _onHoverEnd(),
      child: Listener(
        onPointerMove: widget.autoRotate ? null : (details) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final localPosition = renderBox.globalToLocal(details.position);
            _updateRotation(localPosition, renderBox.size);
          }
        },
        onPointerUp: (_) => _resetRotation(),
        onPointerCancel: (_) => _resetRotation(),
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _hoverController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)  // Perspective
                  ..rotateX(_x)
                  ..rotateY(_y),
                alignment: Alignment.center,
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}