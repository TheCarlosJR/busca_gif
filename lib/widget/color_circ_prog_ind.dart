
import 'package:flutter/material.dart';


class ColorCircularProgressIndicator extends StatefulWidget {
  ColorCircularProgressIndicator({
    Key? key,
    this.animationDuration = 2,
    this.beginColor = Colors.blue,
    this.endColor = Colors.red,
  }) : super(key: key);


  int animationDuration;
  Color beginColor;
  Color endColor;


  @override
  State<ColorCircularProgressIndicator> createState()
  {
    return _ColorCircularProgressIndicatorState(
      animationDuration: animationDuration,
      beginColor: beginColor,
      endColor: endColor,
    );
  }
}


class _ColorCircularProgressIndicatorState extends State<ColorCircularProgressIndicator>
    with TickerProviderStateMixin {
  _ColorCircularProgressIndicatorState({
    this.animationDuration = 2,
    this.beginColor = Colors.blue,
    this.endColor = Colors.red,
  });


  int animationDuration;
  Color beginColor;
  Color endColor;


  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;


  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(
            vsync: this,
            duration: Duration(
                seconds: animationDuration,
            )
        );

    _colorAnimation = ColorTween(
        begin: beginColor, // Cor inicial
        end: endColor, // Cor final
      ).animate(_animationController);

    _animationController.repeat(reverse: true);
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 5,
      valueColor: _colorAnimation,//AlwaysStoppedAnimation<Color>(_colorAnimation.value!),
    );
  }
}