import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedTextOverImage extends StatefulWidget {
  const AnimatedTextOverImage({super.key});

  @override
  State<AnimatedTextOverImage> createState() => _AnimatedTextOverImageState();
}

class _AnimatedTextOverImageState extends State<AnimatedTextOverImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                'assets/images/servMedical.jpg',
                fit: BoxFit.cover,
              ),
            )),
        Positioned(
          top: 0.2.sh,
          left: 20.w,
          right: 20.w,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Text(
              'EARLY DETECTION\nBETTER PROTECTION',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 8.r,
                    color: Colors.black45,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

