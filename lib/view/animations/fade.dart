import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class Fade extends StatefulWidget {
  final double delay;
  final Widget child;

  Fade(this.delay, this.child);

  @override
  _FadeState createState() => _FadeState();
}

class _FadeState extends State<Fade> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _translateY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _translateY = Tween<double>(begin: -130.0, end: 0.0)
        .animate(_controller..curve(Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    startAnimation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(
          offset: Offset(0, _translateY.value),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }

  void startAnimation() {
    _controller.forward();
  }
}




// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';
//
// enum AnimationProps { opacity, translateY }
//
// class Fade extends StatelessWidget {
//   final double delay;
//   final Widget child;
//
//   Fade(this.delay, this.child);
//
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTween<AnimationProps>()
//       ..add(AnimationProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
//       ..add(AnimationProps.translateY, (-130.0).tweenTo(0.0), 500.milliseconds,
//           Curves.easeOut);
//
//     return PlayAnimation<MultiTweenValues<AnimationProps>>(
//       delay: Duration(milliseconds: (500 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builder: (context, child, value) => Opacity(
//         opacity: value.get(AnimationProps.opacity),
//         child: Transform.translate(
//             offset: Offset(0, value.get(AnimationProps.translateY)),
//             child: child),
//       ),
//     );
//   }
// }
