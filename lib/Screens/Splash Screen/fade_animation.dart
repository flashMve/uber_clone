import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { x, y, opacity }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({Key? key, this.delay = 1, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = TimelineTween<AniProps>()
      ..addScene(
        end: const Duration(seconds: 1),
        duration: const Duration(milliseconds: 500),
      ).animate(
        AniProps.opacity,
        tween: Tween(begin: 0.0, end: 1.0),
      )
      ..addScene(
        end: const Duration(seconds: 1),
        duration: const Duration(milliseconds: 500),
      ).animate(
        AniProps.y,
        tween: Tween(begin: -130.0, end: 0.0),
        curve: Curves.easeInOut,
      );

    return PlayAnimation<TimelineValue<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: t.duration,
      tween: t,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, animation.get(AniProps.y)), child: child),
      ),
    );
  }
}

class FadeAnimationChild extends StatelessWidget {
  final AniProps prop;
  final Widget child;
  final int delay;

  const FadeAnimationChild(
      {Key? key, this.prop = AniProps.x, required this.child, this.delay = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = TimelineTween<AniProps>()
      ..addScene(
        begin: const Duration(milliseconds: 100),
        duration: const Duration(milliseconds: 100),
      ).animate(
        AniProps.opacity,
        tween: Tween(begin: 0.0, end: 1.0),
      )
      ..addScene(
        begin: const Duration(milliseconds: 100),
        duration: const Duration(milliseconds: 100),
      ).animate(
        prop,
        tween: Tween(begin: -130.0, end: 0.0),
        curve: Curves.easeInOut,
      );

    return PlayAnimation<TimelineValue<AniProps>>(
      delay: Duration(milliseconds: ((100) * delay).round()),
      duration: t.duration,
      tween: t,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(prop == AniProps.x ? animation.get(AniProps.x) : 0,
                prop == AniProps.y ? animation.get(AniProps.y) : 0),
            child: child),
      ),
    );
  }
}

// class FadeAnimation extends StatefulWidget {
//   final Widget child;
//   const FadeAnimation({Key? key, required this.child}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() => _Fade();
// }

// class _Fade extends State<FadeAnimation> with TickerProviderStateMixin {
//   late AnimationController animation;
//   late Animation<double> _fadeInFadeOut;

//   @override
//   void initState() {
//     super.initState();
//     animation = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);
//     animation.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fadeInFadeOut,
//       child: widget.child,
//     );
//   }
// }
